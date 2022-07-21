#!/bin/bash

source ./common.sh
lib_install_cluster() {
		VPCID=$1

    ssmParamName="/mufawskops/dev/ssh_pk_$KOPS_CLUSTER_NAME"
    echo "<<====== Creating Cluster  ======>>"
    sudo ssh-keygen -q -t rsa -N '' -m PEM -f ~/.ssh/id_rsa <<<y >/dev/null 2>&1
    kops create secret --name $KOPS_CLUSTER_NAME sshpublickey admin -i ~/.ssh/id_rsa.pub
    chmod 600 ~/.ssh/id_rsa

    echo "<<====  Saving Private key in SSM Parameter ====>>"
        keyContent=$(cat '/root/.ssh/id_rsa')
        aws ssm put-parameter \
            --name $ssmParamName \
            --type "String" \
            --value "$keyContent" \
            --overwrite \
            --region "us-east-1" 
    setEc2Tag "SSH_Private_Key_SSMParam" $ssmParamName
    setEc2Tag "Node Connect Command" "ssh ubuntu@<ip_or_dns> -i ~/.ssh/id_rsa"
    echo "Private key for SSHing in to the nodes is saved in SSM param: $ssmParamName"
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
        --node-count=3 \
        --node-size=t2.medium \
        --master-size=t2.medium \
        --master-volume-size="16" \
        --node-volume-size="32" \
        --networking=calico \
        --topology=public \
        --state=$KOPS_STATE_STORE \
        --cloud-labels="Stack=K8sHN,By=Kops" \
        --vpc=$VPCID #vpc-021158bf62c6b829c

    echo "<<=== Editing Instance group to use spot instances ===>>"
    sleep 30s

    kops get ig master-us-east-1a -o yaml > mig.yaml
    kops get ig nodes-us-east-1a -o yaml > wig.yaml

    yq -i e '.spec.maxPrice |= "0.10"' mig.yaml
    yq -i e '.spec.maxPrice |= "0.10"' wig.yaml
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

lib_wiatForClusterReadyLoop() {
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

lib_confugure_kubectlClient() {
    echo "<<====== Configuring Machine  ======>>"

    echo "<<====== Mapping kubectl to kube config created by Kops  ======>>"
    kops export kubecfg --admin
    echo "kops export kubecfg --admin" >> ~/.bashrc 
    # source ~/.bashrc
    echo "<<====== Done Mapping kubectl to kube config created by Kops  ======>>"

    echo "<<====== Done Configuring Machine  ======>>"    
}