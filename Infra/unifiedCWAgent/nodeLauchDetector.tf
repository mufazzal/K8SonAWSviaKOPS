resource "aws_cloudwatch_event_rule" "node_launch_detector_event_rule" {
    name = "node-launch-detector"
    description = "Run on each instance launch"
    event_pattern = <<EOF
    {
        "source": ["aws.ec2"],
        "detail-type": ["EC2 Instance State-change Notification"],
        "detail": {
            "state": ["running"]
        }
    }
    EOF
}

resource "aws_cloudwatch_event_target" "node_launch_lambda_plg_target" {
    arn = "arn:aws:lambda:us-east-1:388412347424:function:KOPS-K8S-manger-lambda-dev-nodeLaunchLambdaPlg"
    rule = aws_cloudwatch_event_rule.node_launch_detector_event_rule.name
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_rw_fallout_retry_step_deletion_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "KOPS-K8S-manger-lambda-dev-nodeLaunchLambdaPlg"
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.node_launch_detector_event_rule.arn
}
