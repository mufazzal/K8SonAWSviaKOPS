#!/bin/bash

scriptRoot="https://muf-k8s-kops-work-space-bucket.s3.amazonaws.com/Scripts"

loadScript() {
    scriptName=$1
    scriptFileName=$(sed 's/\//-/g' <<<"$scriptName")
    sudo curl -L $scriptRoot/$scriptName -o $scriptFileName
    sudo chmod +x ./$scriptFileName
    source ./$scriptFileName
}

init() {
    loadScript "common.sh"
    loadScript "util.sh"
    doCommonConfig ${state_bucket} ${cluster_name}

    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
    sudo add-apt-repository ppa:rmescandon/yq

    sudo apt-get update
    sudo apt-get install -y \
        curl \
        awscli \
        bash-completion \
        yq

    setUDScriptRuningStatusTag "in_progress"
    setEc2Tag "Name" "K8S_INSTALLER-${cluster_name}"
}

process_install_cluster() {
    loadScript "install_cluster.sh"
    lib_install_cluster ${vpcId}
}

process_install_ingressNginx() {
    loadScript "nginxIngContr/install_nginxIngressController.sh"
    lib_install_ingressNginx
}

process_configure_Kubernets_dashBoard() {
    loadScript "kd/setup_kubeDashboard.sh"
    lib_setup_kubernets_dashBoard    
}

process_configure_argoCD_in_cluster() {
    loadScript "argocd/install_argocd.sh"
    lib_install_argoCD     
}

setUpPrometheousAndGrafana() {
    loadScript "promeAndGrafa/install_promeAndGrafa.sh"
    lib_install_PrometheousAndGrafana
}

process_install_certMAnager () {
    loadScript "certManager/install_certManager.sh"
    lib_install_certMAnager
}

process_install_andConfigure_dependencies () {
    loadScript "install_dependencies.sh"
    lib_install_dependencies
    lib_configureCliHandyTool $KOPS_STATE_STORE $KOPS_CLUSTER_NAME
}

process_install_EFK() {    
    loadScript "efk/install_EFK.sh"
    lib_install_EFK    
}

process_install_istio() {    
    loadScript "istio/install_istio.sh"
    lib_install_istio    

    lib_confugure_istio_helloNode
    lib_confugure_istio_hn_ms
}

process_configure() {
    loadScript "install_cluster.sh"
    lib_confugure_kubectlClient
}

doHPAbadFix() {
    echo "<<====== BAD FIX! BAD fix! BAD fix! for HPA AS argo CD do not recognise HPA object ======>>"
    sleep 30s
    sudo mkdir /root/hpaBadFix/
    sudo curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/BAD_FIX/pod-autoscalling.yaml -o /root/hpaBadFix/pod-autoscalling.yaml
    kubectl apply -f /root/hpaBadFix/pod-autoscalling.yaml
    echo "<<====== DONE BAD FIX! BAD fix! BAD fix! for HPA  ======>>"
}



echo '<<======Starting User data Script userData.sh======>>'

init

setProgressInfoTag "begin | Installing/Configuring Prerequsites"
process_install_andConfigure_dependencies

if kops get cluster ; then
    setProgressInfoTag "Prerequsites Installed/Configured | Configuring Preinstlled Cluster"
    echo "Cluster $KOPS_CLUSTER_NAME already created. So we will configure this machine to use it"
    process_configure
else
    setProgressInfoTag "Prerequsites Installed/Configured | Installing Cluster"
    echo "Cluster $KOPS_CLUSTER_NAME not yet created. So it will be created now"
    process_install_cluster

    setProgressInfoTag "Cluster Installed | Wait for Cluster get Ready"
    lib_wiatForClusterReadyLoop
    setProgressInfoTag "Cluster ready | Post Configuring Cluter"
    process_configure

    setProgressInfoTag "Post Configuring Cluster | Configuring Prometheus and Grafana"
    setUpPrometheousAndGrafana

    setProgressInfoTag "Prometheus and Grafana Configured | Configuring ingress-nginx"
    process_install_ingressNginx

    setProgressInfoTag "ingress-nginx Configured| Configuring ArgoCD"
    process_configure_argoCD_in_cluster

    setProgressInfoTag "ArgoCD Configured | Configuring Kubernets-dashBoard"
    process_configure_Kubernets_dashBoard

    setProgressInfoTag "Kubernets-dashBoard Configured | Configuring Cert Manager"
    process_install_certMAnager
    
    setProgressInfoTag "Cert Manager Configured | Configuring EFK stack"
    process_install_EFK

    setProgressInfoTag "EFK Configured | Configuring istio"
    process_install_istio

    doHPAbadFix

    lib_setupCronForDeleteCluster    
  
fi

setProgressInfoTag "none"
setUDScriptRuningStatusTag "COMPLETED"

echo '<<======User data script userData.sh ENDS HERE======>>'
exit 0

# tail -f /var/log/cloud-init-output.log