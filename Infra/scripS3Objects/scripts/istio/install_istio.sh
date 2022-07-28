#!/bin/bash

source ./common.sh
lib_install_istio () {
    helm repo add istio https://istio-release.storage.googleapis.com/charts
    helm repo update

    sudo curl -LO $scriptRoot/istio/helmValues_istio.yaml
    sudo curl -LO $scriptRoot/istio/helmValues_istiod.yaml
    sudo curl -LO $scriptRoot/istio/helmValues_istioig.yaml

    helm upgrade --install istio-base istio/base \
    -n istio-system --create-namespace \
    --wait --timeout 5m \
    -f helmValues_istio.yaml

    helm upgrade --install istiod istio/istiod \
    -n istio-system \
    --wait --timeout 5m \
    -f helmValues_istiod.yaml

    # Lets use our own ingress controller rather then istio's
    # helm upgrade --install istio-ingress istio/gateway \
    # -n istio-system \
    # -f helmValues_istioig.yaml
    # --wait --timeout 5m \  

    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/kiali.yaml
    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.14/samples/addons/prometheus.yaml    
}   

lib_confugure_istio_helloNode() {
    kubectl label namespace hello-node istio-injection=enabled
}

lib_confugure_istio_hn_ms() {
    kubectl label namespace hn_ms1 istio-injection=enabled
    kubectl label namespace hn_ms2 istio-injection=enabled
    kubectl label namespace hn_ms3 istio-injection=enabled
}