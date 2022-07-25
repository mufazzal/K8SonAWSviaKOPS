#!/bin/bash

source ./common.sh


lib_install_EFK() {
    lib_install_fluentd
    lib_install_elasticSearch
    lib_install_kibana
}

lib_install_kibana() {
    helm repo add elastic https://helm.elastic.co   
    helm repo update

    sudo curl -LO $scriptRoot/efk/helmValues_kibana.yaml

    helm upgrade --install kibana elastic/kibana \
    -n efk --create-namespace \
    -f helmValues_kibana.yaml \
    --wait --timeout 5m \
    --version 7.13.0
}

lib_install_elasticSearch() {
    helm repo add elastic https://helm.elastic.co   
    helm repo update

    sudo curl -LO $scriptRoot/efk/helmValues_ecs.yaml

    helm upgrade --install elasticsearch elastic/elasticsearch \
    -n efk --create-namespace \
    -f helmValues_ecs.yaml \
    --wait --timeout 5m \
    --version 7.13.0
}


lib_install_fluentd() {
    helm repo add fluent https://fluent.github.io/helm-charts
    helm repo update

    sudo curl -LO $scriptRoot/efk/helmValues_fluentd.yaml

    helm upgrade --install fluentd fluent/fluentd \
    -n efk --create-namespace \
    --wait --timeout 5m \
    -f helmValues_fluentd.yaml
}


# node-role.kubernetes.io/master:NoSchedule