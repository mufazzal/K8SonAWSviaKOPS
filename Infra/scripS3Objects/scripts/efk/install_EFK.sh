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

    echo "---Installing elasticsearch stat exporter for prometheous ---"

    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo update

    sudo curl -LO $scriptRoot/efk/helmValues_ecs_state_expo.yaml
    helm upgrade --install ecs-stat-exporter prometheus-community/prometheus-elasticsearch-exporter \
    -n efk --create-namespace \
    -f helmValues_ecs_state_expo.yaml    

}


lib_install_fluentd() {
    helm repo add fluent https://fluent.github.io/helm-charts
    helm repo update

    sudo curl -LO $scriptRoot/efk/helmValues_fluentd.yaml
    awsCredContent=$(sudo curl $scriptRoot/efk/awscred)
    IFS=: read -r aws_access_key aws_secret <<< "$awsCredContent"
    sed -i -e "s/<<---AWS_ACCESS_KEY--->>/$aws_access_key/g" helmValues_fluentd.yaml
    sed -i -e "s/<<---AWS_SECRET--->>/$aws_secret/g" helmValues_fluentd.yaml

    helm upgrade --install fluentd fluent/fluentd \
    -n efk --create-namespace \
    --wait --timeout 5m \
    -f helmValues_fluentd.yaml
}


# node-role.kubernetes.io/master:NoSchedule