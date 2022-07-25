#!/bin/bash
scriptRoot="https://muf-k8s-kops-work-space-bucket.s3.amazonaws.com/Scripts"
INSTANCE_ID=$(curl --silent http://169.254.169.254/latest/meta-data/instance-id)
INSTANCE_IP=$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)

doCommonConfig() {
    state_bucket=$1
    cluster_name=$2    
    echo 'alias udlog="cat /var/log/cloud-init-output.log"' >>~/.bashrc
    echo 'alias udlogf="tail -f /var/log/cloud-init-output.log"' >>~/.bashrc  
    export KOPS_STATE_STORE=$state_bucket
    export KOPS_CLUSTER_NAME=$cluster_name    
    echo "export KOPS_STATE_STORE=$state_bucket" >> ~/.bashrc 
    echo "export KOPS_CLUSTER_NAME=$cluster_name" >> ~/.bashrc     
}

setEc2Tag() {
    aws ec2 create-tags \
        --resources $INSTANCE_ID \
        --tags Key="$1",Value="$2" \
        --region us-east-1 
}

setProgressInfoTag() {
    setEc2Tag "ProgressInfoTag" "$1"
}

setUDScriptRuningStatusTag() {
    setEc2Tag "UDScriptRuningStatus" "$1"
}
