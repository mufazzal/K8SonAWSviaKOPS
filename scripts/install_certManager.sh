#!/bin/bash

source ./common.sh
lib_install_certMAnager () {
    helm repo add jetstack https://charts.jetstack.io
    helm repo update
    helm install cert-manager jetstack/cert-manager \
        --namespace cert-manager --create-namespace \
        --version v1.8.2 \
        --set installCRDs=true \
        --set prometheus.enabled=true \
        --set prometheus.servicemonitor.enabled=true

}