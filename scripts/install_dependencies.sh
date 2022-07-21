#!/bin/bash
source ./common.sh

lib_install_dependencies() {

    echo "<<====== Installing Kubectl and addons ======>>"

    sudo curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    sudo mv ./kubectl /usr/local/bin/kubectl

    sudo git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    sudo ~/.fzf/install --all

    sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
    sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
    sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

    echo "<<====== DONE Installing Kubectl and addons ======>>"

    echo "<<====== Installing Kops ======>>"

    curl -Lo kops https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
    chmod +x kops
    sudo mv kops /usr/local/bin/kops

    echo "<<====== DONE Installing Kops  ======>>"


    echo "<<====== Installing Helm ======>>"

    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    helm version

    echo "<<====== DONE Installing Helm  ======>>"

    echo "<<====== Installing K9s ======>>"


    wget https://github.com/derailed/k9s/releases/download/v0.25.18/k9s_Linux_x86_64.tar.gz
    tar -xvzf k9s_Linux_x86_64.tar.gz
    sudo install k9s /usr/local/bin/

    echo "<<====== DONE Installing K9s ======>>"
}

lib_configureCliHandyTool() {

    echo "<<====== Configuring CLIs ======>>"

    echo 'source /usr/share/bash-completion/bash_completion' >>~/.bashrc
    echo 'source <(kubectl completion bash)' >>~/.bashrc
    echo 'complete -F __start_kubectl k' >>~/.bashrc
    echo 'alias k=kubectl' >>~/.bashrc
    echo 'alias kn=kubens' >>~/.bashrc

    echo "<<====== DONE Configuring CLI  ======>>"    

}