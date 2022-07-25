#!/bin/bash

source ./common.sh
lib_install_ingressNginx() {
    echo "<<====== Setting up ingress inginx  ======>>"

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update

    sudo curl -LO $scriptRoot/nginxIngContr/helmValues_nginx.yaml

    helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
    -n ingress-nginx --create-namespace \
    --wait --timeout 5m \
    -f helmValues_nginx.yaml

    # helm upgrade --install ingress-nginx ingress-nginx \
    # --repo https://kubernetes.github.io/ingress-nginx \
    # --namespace ingress-nginx --create-namespace \
    # --set controller.metrics.enabled=true \
    # --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
    # --set-string controller.podAnnotations."prometheus\.io/port"="10254" \
    # --set controller.metrics.serviceMonitor.enabled=true \
    # --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus"    
    # #--set service.metadata.annotations."service\.beta\.kubernetes\.io/aws-load-balancer-type"="nlb" 

    sleep 15
    #Use this if you wants to ssl termination for argo CD case. For now argo CD not working with ingress.
    kubectl -n ingress-nginx patch deployment ingress-nginx-controller \
    --type=json \
    -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--enable-ssl-passthrough"}]'

    kubectl annotate service ingress-nginx-controller -n ingress-nginx \
        service.beta.kubernetes.io/aws-load-balancer-type=nlb \
        --overwrite

    sleep 1m

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
                elbIP=$(aws ec2 describe-network-interfaces --filters Name=description,Values="ELB net/$albDesc" --query 'NetworkInterfaces[0].Association.PublicIp' --output text --region us-east-1)
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

    echo "<< Enabling Cross-Zone Load balancing >>"  
    
    sleep 1m

    lbarn=$(aws elbv2 describe-load-balancers --region us-east-1 --query 'LoadBalancers[0].LoadBalancerArn' --output text)
    aws elbv2 modify-load-balancer-attributes \
        --load-balancer-arn $lbarn \
        --attributes Key=load_balancing.cross_zone.enabled,Value=true \
        --region us-east-1

    echo "<< Done Enabling Cross-Zone Load balancing >>"  


}