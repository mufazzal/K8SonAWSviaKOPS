#!/bin/bash

source ./common.sh

lib_setup_kubernets_dashBoard() {
    # kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.6.0/aio/deploy/recommended.yaml
    # above line is commented out as k-d is npw part of argi pipeline
    
    # wait fror service account creation. better have the while loop  

    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    helm repo update

    sudo curl -LO $scriptRoot/kd/helmValues_kd.yaml

    helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
    -f helmValues_kd.yaml \
    --wait --timeout 5m \
    -n kubernetes-dashboard --create-namespace

    sleep 30s

    kubectl create \
        -n kubernetes-dashboard \
        -f https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/modules/kd/kubernetes-dashboard-admin-role-binding.yaml


    echo "<<====  Saving Kubernetes Dashboard Token in SSM Parameter ====>>"
        ssmParamName="/mufawskops/dev/kd_token"
        saToken=$(kubectl get serviceaccount kd-admin -n kubernetes-dashboard -o=jsonpath='{.secrets[0].name}' | xargs kubectl get secret -n kubernetes-dashboard -o jsonpath='{.data.token}' | base64 --decode)
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