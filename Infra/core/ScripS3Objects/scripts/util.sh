#!/bin/bash

source ./common.sh
lib_setupCronForDeleteCluster() {
    echo "<<====== Setting Cron job for Deleting cluster  ======>>"

    sudo mkdir /root/k8sHNResources/
    sudo curl https://raw.githubusercontent.com/mufazzal/HelloNodeAutomation/master/Deployment/dev/k8sClusterDepAWSKOPS/resources/deleteCluster.sh -o /root/k8sHNResources/deleteClusterCron.sh
    sudo chmod +x /root/k8sHNResources/deleteClusterCron.sh
    
    (sudo crontab -l 2>/dev/null; echo "0 17 * * * /root/k8sHNResources/deleteClusterCron.sh") | sudo crontab -
    # 0 17 * * * in UTC is 22:30 PM india
    # grep CRON /var/log/syslog
    echo "<<====== DONE Setting Cron job for Deleting cluster  ======>>"

}