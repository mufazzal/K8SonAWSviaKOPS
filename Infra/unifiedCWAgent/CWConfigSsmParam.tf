resource "aws_ssm_parameter" "CWConfigSSMParam" {
  name  = "${var.CWConfigSSMParam}"
  type  = "String"
  value = jsonencode({
        "agent": {
                "metrics_collection_interval": 60,
                "run_as_user": "root"
        },
        "logs": {
                "logs_collected": {
                        "files": {
                                "collect_list": [
                                        {
                                                "file_path": "/var/log/syslog",
                                                "log_group_name": "syslog",
                                                "log_stream_name": "{instance_id}",
                                                "retention_in_days": 3
                                        },
                                        {
                                                "file_path": "/var/log/cloud-init.log",
                                                "log_group_name": "cloud-init-log",
                                                "log_stream_name": "{instance_id}",
                                                "retention_in_days": 3
                                        },
                                                                                {
                                                "file_path": "/var/log/cloud-init-output.log",
                                                "log_group_name": "cloud-init-output-log",
                                                "log_stream_name": "{instance_id}",
                                                "retention_in_days": 3
                                        }                                 

                                ]
                        }
                }
        },
        "metrics": {
                "aggregation_dimensions": [
                        [
                                "InstanceId"
                        ]
                ],
                "append_dimensions": {
                        "AutoScalingGroupName": "$${aws:AutoScalingGroupName}",
                        "ImageId": "$${aws:ImageId}",
                        "InstanceId": "$${aws:InstanceId}",
                        "InstanceType": "$${aws:InstanceType}"
                },
                "metrics_collected": {
                        "disk": {
                                "measurement": [
                                        "used_percent"
                                ],
                                "metrics_collection_interval": 60,
                                "resources": [
                                        "*"
                                ]
                        },
                        "mem": {
                                "measurement": [
                                        "mem_used_percent"
                                ],
                                "metrics_collection_interval": 60
                        },
                        "statsd": {
                                "metrics_aggregation_interval": 60,
                                "metrics_collection_interval": 10,
                                "service_address": ":8125"
                        }
                }
        }
    })
}