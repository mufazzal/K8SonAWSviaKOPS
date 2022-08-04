echo "whoooooo, i am in k8sKopsEC2ImageBuilder/script.sh"

scriptRoot="https://muf-k8s-kops-work-space-bucket.s3.amazonaws.com/Scripts"

loadScript() {
    scriptName=$1
    scriptFileName=$(sed 's/\//-/g' <<<"$scriptName")
    sudo curl -L $scriptRoot/$scriptName -o $scriptFileName
    sudo chmod +x ./$scriptFileName
    source ./$scriptFileName
}

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys CC86BB64
sudo add-apt-repository ppa:rmescandon/yq

sudo apt-get update
sudo apt-get install -y \
    curl \
    awscli \
    bash-completion \
    yq

loadScript "install_dependencies.sh"
lib_install_dependencies    