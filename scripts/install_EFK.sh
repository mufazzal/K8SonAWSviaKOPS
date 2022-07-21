#!/bin/bash

source ./common.sh

lib_install_EFK() {
    helm repo add elastic https://helm.elastic.co   
    helm repo update
    echo "labels:      
  stack: EFK
tolerations:
  - key: 'node-role.kubernetes.io/master'
    operator: 'Exists'
    effect: 'NoSchedule'  " > esvalues.yaml    
    helm upgrade --install elasticsearch elastic/elasticsearch \
    -n efk --create-namespace \
    -f esvalues.yaml \
    --version 7.13.0
}

# node-role.kubernetes.io/master:NoSchedule