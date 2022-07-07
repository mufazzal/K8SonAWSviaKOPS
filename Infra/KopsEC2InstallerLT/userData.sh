#!/bin/bash
process_install_cluster() {
    echo "<<====== Creating Cluster  ======>>"
    sudo ssh-keygen -q -t rsa -N '' -m PEM -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    kops create secret --name $KOPS_CLUSTER_NAME sshpublickey admin -i ~/.ssh/id_rsa.pub

    echo "<<====  Saving Private key in SSM Parameter ====>>"
        ssmParamName="/mufawskops/dev/ssh_pk_$KOPS_CLUSTER_NAME"
        keyContent=$(cat '/root/.ssh/id_rsa')
        aws ssm put-parameter \
            --name $ssmParamName\
            --type "String" \
            --value "$keyContent" \
            --overwrite \
            --region "us-east-1" 
        echo "Private key for SSHing in to the nodes is saved in "
        setEc2Tag "SSH_Private_Key_SSMParam" $ssmParamName
    echo "<<====  Done Saving Private key in SSM Parameter ====>>"

    # save content of ~/.ssh/id_rsa to SSH from anywhere.

    sudo kops create cluster \
        --cloud=aws \
        --zones=us-east-1a \
        --name=$KOPS_CLUSTER_NAME \
        --ssh-public-key="~/.ssh/id_rsa.pub" \
        --ssh-access="0.0.0.0/0" \
        --dns-zone=k8shn.com \
        --dns private \
        --node-count=2 \
        --node-size=t2.medium \
        --master-size=t2.medium \
        --networking=calico \
        --topology=public \
        --state=$KOPS_STATE_STORE \
        --cloud-labels="Stack=K8sHN,By=Kops" \
        --vpc=${vpcId} #"vpc-021158bf62c6b829c"

        # --target="terraform" \ Not using it because its not creating Spot instances.
        # --v=5 \ Use it if you need more debug log
        # --network-cidr="10.12.0.0/16" \ Because of Error CIDR: Forbidden: field is immutable: old="10.0.0.0/16" new="10.12.0.0/16"

        # cd out/terraform
        # terraform init
        # terraform apply --auto-approve

        echo "<<=== Editing Instance group to use spot instances ===>>"
        sleep 30s
        kops get ig -o yaml > igs.yaml

# BAD way to edit the yaml, because yq do not support ---
sed -i 's/spec:/spec:\
  maxPrice: "0.10"/g' igs.yaml

        kops replace -f igs.yaml --force
        kops get ig -o yaml
        echo "<<=== Done Editing Instance group to use spot instances ===>>"



        echo "<<=== Editing cluster to emable use of metrics server ===>>"
        sleep 30s
        kops get cluster -o yaml > cluster.yaml

        yq -i e '.spec.certManager.enabled |= true' cluster.yaml
        yq -i e '.spec.certManager.managed |= false' cluster.yaml
        yq -i e '.spec.metricsServer.enabled |= true' cluster.yaml

        kops replace -f cluster.yaml --force
        kops get cluster -o yaml
        echo "<<=== Done Editing cluster to emable use of metrics server ===>>"


    kops update cluster --yes

    echo "<<====== Done Creating Cluster  ======>>"
}
process_configure_ingressNginx_in_cluster() {
    echo "<<====== Setting up ingress inginx  ======>>"

    # helm upgrade --install ingress-nginx ingress-nginx \
    # --repo https://kubernetes.github.io/ingress-nginx \
    # --namespace ingress-nginx --create-namespace

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml
    sleep 15
    #Use this if you wants to ssl termination for argo CD case. For now argo CD not working with ingress.
    kubectl -n ingress-nginx patch deployment ingress-nginx-controller \
    --type=json \
    -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--enable-ssl-passthrough"}]'

    while true;
    do
        cs=$(kubectl get svc ingress-nginx-controller -n ingress-nginx -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
        if [[ $cs == *"amazonaws.com"* ]]; then
            echo "Load balancer is up now. waiting to get its allocated public IP address"

            albid=$(echo $cs | cut -f1 -d".")
            albDesc=$(echo "$albid" | sed -r 's/\-/\//g')
            while true;
            do
                elbIP=$(aws ec2 describe-network-interfaces --filters Name=description,Values="ELB net/$albDesc" --query 'NetworkInterfaces[*].Association.PublicIp' --output text --region us-east-1)
                if [[ $elbIP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                    echo "Load balancer Public IP is: $elbIP"
                    setEc2Tag "LB IP" $elbIP
                    break;
                else
                    echo "Load balancer did not yet have public IP.. retry in 5 seconds"
                fi
            done
            
            echo "IP of Load balancer is: $elbIP"
            break
        else 
            echo "Load balancer is still not ready.. retry in 10 seconds"
            sleep 10
        fi
    done   

}

process_configure_Kubernets_dashBoard() {
    # kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.0/aio/deploy/recommended.yaml
    # above line is commented out as k-d is npw part of argi pipeline
    
    # wait fror service account creation. better have the while loop  
    sleep 30s

    echo "<<====  Saving Kubernetes Dashboard Token in SSM Parameter ====>>"
        ssmParamName="/mufawskops/dev/kd_token"
        saToken=$(kubectl get serviceaccount jmutai-admin -o=jsonpath='{.secrets[0].name}' | xargs kubectl get secret -ojsonpath='{.data.token}' | base64 --decode)
        aws ssm put-parameter \
            --name $ssmParamName\
            --type "String" \
            --value "$saToken" \
            --overwrite \
            --region "us-east-1" 
        echo "Kubernetes Dashboard Token for SSHing in to the nodes is saved in SSM Param: $ssmParamName"
        setEc2Tag "kd_token_SSMParam" $ssmParamName
    echo "<<====  Done Saving Kubernetes Dashboard Token in SSM Parameter ====>>"    

}

process_configure_argoCD_in_cluster() {
    echo "<<====== Initializing Argo CD in Cluster  ======>>"
    # kops export kubecfg --admin --name=$KOPS_CLUSTER_NAME --state $KOPS_STATE_STORE

    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    sleep 1m
    echo "^^^USERNAME FOR ARGOCD UI IS admin^^^^"
    echo "^^^PASSWORD FOR ARGOCD UI IS PRINTED BELOW^^^^"
    argoInitPsw=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;)
    echo $argoInitPsw
    # aws ec2 create-tags \
    #     --resources $INSTANCE_ID \
    #     --tags Key=argoInitPsw,Value=$argoInitPsw \
    #     --region us-east-1

    curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/argocdHNInit.yaml -o argocdHNInit.yaml
    kubectl apply -f argocdHNInit.yaml

    # sudo nohup kubectl port-forward svc/argocd-server -n argocd 8080:443 --address 0.0.0.0 &
    
    echo "<<=== Argo CD available at http://$INSTANCE_IP:8080"
    setEc2Tag "argoInit" "admin | $argoInitPsw"

    echo "<<====== Done Initializing Argo CD in Cluster  ======>>"
}

process_configure() {
    echo "<<====== Configuring Machine  ======>>"

    echo "<<====== Mapping kubectl to kube config created by Kops  ======>>"
    kops export kubecfg --admin
    echo "kops export kubecfg --admin" >> ~/.bashrc 
    source ~/.bashrc
    echo "<<====== Done Mapping kubectl to kube config created by Kops  ======>>"

    echo "<<====== Done Configuring Machine  ======>>"
}

setProgressInfoTag() {
    setEc2Tag "ProgressInfoTag" "$1"
    # aws ec2 create-tags \
    #     --resources $INSTANCE_ID \
    #     --tags Key=ProgressInfoTag,Value=$taskInfo \
    #     --region us-east-1    
}

setUDScriptRuningStatusTag() {
    setEc2Tag "UDScriptRuningStatus" "$1"
    # aws ec2 create-tags \
    #     --resources $INSTANCE_ID \
    #     --tags Key=UDScriptRuningStatus,Value=$status \
    #     --region us-east-1 
}

setEc2Tag() {
    aws ec2 create-tags \
        --resources $INSTANCE_ID \
        --tags Key="$1",Value="$2" \
        --region us-east-1 
}

wiatForClusterReadyLoop() {
    echo "Cluster is not ready.. hold on!"

    sleep 1m
    kops export kubecfg --admin    
    while true;
    do
        cs=$(kops validate cluster --name=$KOPS_CLUSTER_NAME --state $KOPS_STATE_STORE)
        if [[ $cs == *"is ready"* ]]; then
            echo "Cluster is READY"
            break
        else 
            echo "Cluster is still not ready.. retry in 30 seconds"
            sleep 30
        fi
    done
}


setupCronForDeleteCluster() {
    echo "<<====== Setting Cron job for Deleting cluster  ======>>"

    sudo mkdir /root/k8sHNResources/
    sudo curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/resources/deleteCluster.sh -o /root/k8sHNResources/deleteClusterCron.sh
    sudo chmod +x /root/k8sHNResources/deleteClusterCron.sh
    
    (sudo crontab -l 2>/dev/null; echo "0 17 * * * /root/k8sHNResources/deleteClusterCron.sh") | sudo crontab -
    # 0 17 * * * in UTC is 22:30 PM india
    # grep CRON /var/log/syslog
    echo "<<====== DONE Setting Cron job for Deleting cluster  ======>>"

}

doHPAbadFix() {
    echo "<<====== BAD FIX! BAD fix! BAD fix! for HPA  ======>>"
    sleep 30s
    sudo mkdir /root/hpaBadFix/
    sudo curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/BAD_FIX/pod-autoscalling.yaml -o /root/hpaBadFix/pod-autoscalling.yaml
    kubectl apply -f /root/hpaBadFix/pod-autoscalling.yaml
    echo "<<====== DONE BAD FIX! BAD fix! BAD fix! for HPA  ======>>"
}

echo '<<======Starting User data Script userData.sh======>>'
sudo apt-get update
sudo apt-get install -y \
    curl \
    awscli
INSTANCE_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_IP=$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)

setUDScriptRuningStatusTag "in_progress"
setEc2Tag "Name" "K8S_INSTALLER"
# aws ec2 create-tags \
#     --resources $INSTANCE_ID \
#     --tags Key=Key=Name,Value=K8S_INSTALLER \
#     --region us-east-1
setProgressInfoTag "begin | Installing Prerequsites"

echo "<<====== Installing and updating necessary dependencies ======>>"
sudo apt-get install -y \
    bash-completion

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq
sudo apt-get update
sudo apt-get install yq -y

wget https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
tar -xvzf k9s_Linux_x86_64.tar.gz
sudo install k9s /usr/local/bin/

# git clone https://github.com/derailed/k9s.git mufk9s
# cd mufk9s
# make build
# cd ..

aws --version

echo "<<====== DONE Installing and updating necessary dependencies ======>>"

echo "<<====== Installing Kubectl and addons ======>>"

sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
sudo chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

sudo git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
sudo ~/.fzf/install --all

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

echo "<<====== DONE Installing Kubectl and addons ======>>"

echo "<<====== Installing Kops ======>>"

curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops
sudo mv kops /usr/local/bin/kops

echo "<<====== DONE Installing Kops  ======>>"

# echo "<<====== Installing Terraform  ======>>"
# sudo wget -qO - terraform.gpg https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/terraform-archive-keyring.gpg
# sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/terraform-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/terraform.list
# sudo apt update
# sudo apt install -y terraform
# echo "<<====== DONE Installing Terraform  ======>>"


echo "<<====== Installing Helm ======>>"

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
helm version

echo "<<====== DONE Installing Helm  ======>>"

setProgressInfoTag "Prerequsites Installed | Configuring Prerequsites"

echo "<<====== Configuring CLIs ======>>"

echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'alias k=kubectl' >>~/.bashrc
echo 'alias kn=kubens' >>~/.bashrc
echo 'complete -F __start_kubectl k' >>~/.bashrc

echo "<<====== DONE Configuring CLI  ======>>"


echo "<<====== Intial Configuration  ======>>"


state_bucket="s3://muf-k8s-kops-state-bucket"
cluster_name="hn.k8shn.com"

export KOPS_STATE_STORE=$state_bucket
export KOPS_CLUSTER_NAME=$cluster_name

echo "export KOPS_STATE_STORE=$state_bucket" >> ~/.bashrc 
echo "export KOPS_CLUSTER_NAME=$cluster_name" >> ~/.bashrc 
source ~/.bashrc 

echo "<<====== DONE Intial Configuration  ======>>"


if kops get cluster ; then
    setProgressInfoTag "Prerequsites Configured | Configuring Preinstlled Cluster"
    echo "Cluster $KOPS_CLUSTER_NAME already created. So we will configure this machine to use it"
    process_configure
else
    setProgressInfoTag "Prerequsites Configured | Installing Cluster"
    echo "Cluster $KOPS_CLUSTER_NAME not yet created. So it will be created now"
    process_install_cluster

    setProgressInfoTag "Cluster Installed | Wait for Cluster get Ready"
    wiatForClusterReadyLoop
    setProgressInfoTag "Cluster ready | Post Configuring Cluter"
    process_configure
    setProgressInfoTag "Post Configuring Cluster | Configuring ingress-nginx"
    process_configure_ingressNginx_in_cluster

    setProgressInfoTag "ingress-nginx Configured| Configuring ArgoCD"
    process_configure_argoCD_in_cluster

    setProgressInfoTag "Kubernets-dashBoard Configured | Configuring Kubernets-dashBoard"
    process_configure_Kubernets_dashBoard
    doHPAbadFix

    setupCronForDeleteCluster
  
fi

setProgressInfoTag "none"
setUDScriptRuningStatusTag "COMPLETED"

echo '<<======User data script userData.sh ENDS HERE======>>'



exit 0

# tail -f /var/log/cloud-init-output.log


#-----------------------------


