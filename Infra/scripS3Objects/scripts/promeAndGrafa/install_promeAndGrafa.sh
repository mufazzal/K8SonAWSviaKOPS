#!/bin/bash

source ./common.sh

lib_install_PrometheousAndGrafana() {
    echo '<<======  Installing Prometheus and Grafana  ======>>'

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    # helm repo add stable https://charts.helm.sh/stable
    helm repo update
    # kubectl create ns prometheus
    # #helm install prometheus prometheus-community/kube-prometheus-stack -n prometheus

    sudo curl -LO $scriptRoot/promeAndGrafa/helmValues_promeAndGrafa.yaml

    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    -n prometheus --create-namespace \
    --wait --timeout 5m \
    -f helmValues_promeAndGrafa.yaml

    # helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
    # --namespace prometheus  \
    # --set prometheus.prometheusSpec.podMonitorSelectorNilUsesHelmValues=false \
    # --set prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues=false

    grafanaPassword=$(kubectl get secret prometheus-grafana --namespace prometheus -o jsonpath="{.data.admin-password}" | base64 --decode)
    echo $grafanaPassword
    setEc2Tag "Grafana Cred" "admin | $grafanaPassword"

    echo '<<======  Done Installing Prometheus and Grafana  ======>>'

}