#!/bin/bash

source ./common.sh
lib_install_certMAnager () {

    helm repo add jetstack https://charts.jetstack.io
    helm repo update

    sudo curl -LO $scriptRoot/certManager/helmValues_certManager.yaml    

    helm install cert-manager jetstack/cert-manager \
        -n cert-manager --create-namespace \
        --wait --timeout 5m \
        -f helmValues_certManager.yaml
        # --set installCRDs=true \
        # --set prometheus.enabled=true \
        # --set prometheus.servicemonitor.enabled=true

}