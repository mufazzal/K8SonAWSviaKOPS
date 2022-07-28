#!/bin/bash

source ./common.sh
lib_install_istio () {
    kubectl create namespace istio-system
    helm install istio-base istio/base -n istio-system



}   