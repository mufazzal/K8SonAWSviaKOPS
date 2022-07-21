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
        --kubernetes-version="1.23.2" \
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
        --master-volume-size="16"
        --node-volume-size="32"
        --networking=calico \
        --topology=public \
        --state=$KOPS_STATE_STORE \
        --cloud-labels="Stack=K8sHN,By=Kops" \
        --vpc="vpc-021158bf62c6b829c" #${vpcId}

        echo "<<=== Editing Instance group to use spot instances ===>>"
        sleep 30s

        kops get ig master-us-east-1a -o yaml > mig.yaml
        kops get ig nodes-us-east-1a -o yaml > wig.yaml

        yq -i e '.spec.maxPrice |= 0.10' mig.yaml
        yq -i e '.spec.maxPrice |= 0.10' wig.yaml
        kops replace -f mig.yaml --force
        kops replace -f wig.yaml --force



        echo "<<=== Done Editing Instance group to use spot instances ===>>"


        echo "<<=== Editing cluster to emable use of metrics server ===>>"
        sleep 30s
        kops get cluster -o yaml > cluster.yaml

        yq -i e '.spec.certManager.enabled |= true' cluster.yaml
        yq -i e '.spec.certManager.managed |= false' cluster.yaml
        yq -i e '.spec.metricsServer.enabled |= true' cluster.yaml

        kops replace -f cluster.yaml --force
        echo "<<=== Done Editing cluster to emable use of metrics server ===>>"


    kops update cluster --yes

    echo "<<====== Done Creating Cluster  ======>>"
}
process_configure_ingressNginx_in_cluster() {
    echo "<<====== Setting up ingress inginx  ======>>"

    helm upgrade --install ingress-nginx ingress-nginx \
    --repo https://kubernetes.github.io/ingress-nginx \
    --namespace ingress-nginx --create-namespace \
    --set controller.metrics.enabled=true \
    --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
    --set-string controller.podAnnotations."prometheus\.io/port"="10254" \
    --set controller.metrics.serviceMonitor.enabled=true \
    --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"    
    #--set service.metadata.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" 

    sleep 15
    #Use this if you wants to ssl termination for argo CD case. For now argo CD not working with ingress.
    kubectl -n ingress-nginx patch deployment ingress-nginx-controller \
    --type=json \
    -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--enable-ssl-passthrough"}]'

    kubectl annotate service ingress-nginx-controller -n ingress-nginx \
        service.beta.kubernetes.io/aws-load-balancer-type=nlb \
        --overwrite


    # kubectl -n ingress-nginx patch service ingress-nginx-controller \
    # --type=json \
    # -p='[{"op": "add", "path": "/metadata/annotations", "value": "service.beta.kubernetes.io/aws-load-balancer-type: nlb"}]'
    
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
                    sleep 5
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
        saToken=$(kubectl get serviceaccount jmutai-admin -n kubernetes-dashboard -o=jsonpath='{.secrets[0].name}' | xargs kubectl get secret -n kubernetes-dashboard -ojsonpath='{.data.token}' | base64 --decode)
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

    kubectl create namespace argocd
    helm repo add argo https://argoproj.github.io/argo-helm


    helm upgrade --install argocd argo/argo-cd \
    --namespace argocd \
    --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
    --set-string controller.podAnnotations."prometheus\.io/path"="/metrics" \
    --set-string controller.podAnnotations."prometheus\.io/port"="8090" \
    --set controller.metrics.serviceMonitor.enabled=true \
    --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" 
    sleep 1m

    echo "controller:      
  metrics:   
   enabled: true    
   serviceMonitor:  
    enabled: true     
    additionalLabels:     
     release: prometheus" > argo_val.yaml
    helm upgrade --install argocd argo/argo-cd --namespace argocd -f argo_val.yaml

    echo "^^^USERNAME FOR ARGOCD UI IS admin^^^^"
    echo "^^^PASSWORD FOR ARGOCD UI IS PRINTED BELOW^^^^"
    argoInitPsw=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d;)
    echo $argoInitPsw

    curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/argocdHNInit.yaml -o argocdHNInit.yaml
    kubectl apply -f argocdHNInit.yaml

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

setUpPrometheousAndGrafana() {
    echo '<<======  Installing Prometheus and Grafana  ======>>'

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add stable https://charts.helm.sh/stable
    helm repo update
    kubectl create ns prometheus
    # helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus

    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    --namespace prometheus  \
    --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
    --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

    grafanaPassword=$(kubectl get secret prometheus-grafana --namespace prometheus -o jsonpath="{.data.admin-password}" | base64 --decode)
    echo $grafanaPassword
    setEc2Tag "Grafana Cred" "admin | $grafanaPassword"

    echo '<<======  Done Installing Prometheus and Grafana  ======>>'

}


process_configure_certMAnager () {
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager \
        --namespace cert-manager --create-namespace \
        --version v1.8.2 \
        --set installCRDs=true \
        --set prometheus.enabled=true \
        --set prometheus.servicemonitor.enabled=true

}

process_configure_EFK() {
    helm repo add elastic https://helm.elastic.co   
    helm repo update
    echo "labels:      
  stack: EFK" > esvalues.yaml    
    helm upgrade --install elasticsearch elastic/elasticsearch \
    -n efk --create-namespace \
    -f esvalues.yaml \
    --version 7.13.0
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

echo 'alias udlog="cat /var/log/cloud-init-output.log"' >>~/.bashrc
echo 'alias udlogf="tail -f /var/log/cloud-init-output.log"' >>~/.bashrc

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

    setProgressInfoTag "Post Configuring Cluster | Configuring Prometheus and Grafana"
    setUpPrometheousAndGrafana

    setProgressInfoTag "Prometheus and Grafana Configured | Configuring ingress-nginx"
    process_configure_ingressNginx_in_cluster

    setProgressInfoTag "ingress-nginx Configured| Configuring ArgoCD"
    process_configure_argoCD_in_cluster

    setProgressInfoTag "ArgoCD Configured | Configuring Kubernets-dashBoard"
    process_configure_Kubernets_dashBoard

    setProgressInfoTag "Kubernets-dashBoard Configured | Configuring Cert Manager"
    process_configure_certMAnager
    
    process_configure_EFK

    doHPAbadFix

    setupCronForDeleteCluster
    
  
fi

setProgressInfoTag "none"
setUDScriptRuningStatusTag "COMPLETED"

echo '<<======User data script userData.sh ENDS HERE======>>'



exit 0

# tail -f /var/log/cloud-init-output.log


#-----------------------------


