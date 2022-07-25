#!/bin/bash

source ./common.sh
lib_install_argoCD() {
    echo "<<====== Initializing Argo CD in Cluster  ======>>"

    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update

    sudo curl -LO $scriptRoot/argocd/helmValues_argocd.yaml

    helm upgrade --install argocd argo/argo-cd \
    -n argocd --create-namespace \
    --wait --timeout 5m \
    -f helmValues_argocd.yaml

    # --set-string controller.podAnnotations."prometheus\.io/scrape"="true" \
    # --set-string controller.podAnnotations."prometheus\.io/path"="/metrics" \
    # --set-string controller.podAnnotations."prometheus\.io/port"="8090" \
    # --set controller.metrics.serviceMonitor.enabled=true \
    # --set controller.metrics.serviceMonitor.additionalLabels.release="prometheus" 
  #   sleep 1m

  #   echo "controller:      
  # metrics:   
  #  enabled: true    
  #  serviceMonitor:  
  #   enabled: true     
  #   additionalLabels:     
  #    release: prometheus" > argo_val.yaml
  #  helm upgrade --install argocd argo/argo-cd --namespace argocd -f argo_val.yaml

  #  sleep 1m
    
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