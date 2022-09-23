#!/bin/bash

source ./common.sh
lib_install_ansible() {
    echo "<<====== Installing Ansible  ======>>"

    apt-get install python3
    python3 --version
    apt-get update

    apt-get -y install software-properties-common

    apt-add-repository ppa:ansible/ansible

    apt-get -y update

    apt-get -y install ansible    

    ansible --version

    export ANSIBLE_HOST_KEY_CHECKING=False
    echo 'export ANSIBLE_HOST_KEY_CHECKING=False' >>~/.bashrc

    echo "<<====== Done Installing Ansible  ======>>"

}   

lib_run_ansible_pb() {
    pb=$1

    pb="basicK8sSanity.yaml"
    sudo curl -LO $scriptRoot/ansible/inventory
    sudo curl -L $scriptRoot/ansible/playbooks/$pb -o "ansible-pb-$pb"    

    echo "Running ansilbe Play book $pb on inventory"

    ansible-playbook -i inventory "ansible-pb-$pb"

}