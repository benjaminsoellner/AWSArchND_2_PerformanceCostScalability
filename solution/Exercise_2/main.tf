# designate a cloud provider, region, and credentials
provider "aws" {
  access_key = "???"
  secret_key = "???"
  token = "???"
  region = var.region
}

# provision 2 m4.large EC2 instances named Udacity M4
resource "aws_instance" "Udacity_M4" {
  count = "2"
  ami = var.ami
  instance_type = "m4.large"
  tags = {
      Name = "Udacity T2"
  }
  subnet_id = var.subnet_id
}

# IAM role
resource "aws_iam_role" "iam_role_lambda" {
  name = "iam-role-lambda"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

# IAM policy to allow lambda function to log events
resource "aws_iam_policy" "iam_policy_lambda_logging" {
  name  = "iam-policy-lambda-logging"
  path = "/"
  description = "Policy allowing lambda function to write cloudwatch logs"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Role Policy Attachment
resource "aws_iam_role_policy_attachment" "lambda_logging_iam_role_policy_attachment" {
  role = aws_iam_role.iam_role_lambda.name
  policy_arn = aws_iam_policy.iam_policy_lambda_logging.arn
}

# Provides a Lambda Function resource
resource "aws_lambda_function" "lambda_greet" {
  function_name = "lambda-greet"
  filename = "greet_lambda.zip"
  source_code_hash = filebase64sha256("greet_lambda.zip")
  handler = "greet_lambda.lambda_handler"
  role = aws_iam_role.iam_role_lambda.arn
  runtime = "python3.8"

  environment {
    variables = {
      greeting = "Hello, Udacity!"
    }
  }
}

# Provides a CloudWatch Log Group resource
resource "aws_cloudwatch_log_group" "log_group_lambda_greet" {
  name = "/aws/lambda/${aws_lambda_function.lambda_greet.function_name}"
  retention_in_days = 5
}
