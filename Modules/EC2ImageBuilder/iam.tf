resource "aws_iam_role" "iamRole" {
  name = "${var.prefix}-${var.pipelineName}-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_agent_access" {
  role        = aws_iam_role.iamRole.id
  policy_arn  = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.iamRole.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },         
    ]
  })
}


resource "aws_iam_instance_profile" "iamProfile" {
  name = "${var.prefix}-${var.pipelineName}-instance-profile"
  role = aws_iam_role.iamRole.name
}
