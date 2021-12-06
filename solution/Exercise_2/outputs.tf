# Define the output variable for the lambda function.
output "lambda_greeting" {
    value = aws_lambda_function.lambda_greet.environment[0].variables["greeting"]
}