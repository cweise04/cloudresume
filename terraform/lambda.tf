

# Create a Lambda function and attach the correct Iam permissions
resource "aws_lambda_function" "cw_resume_lambda" {
  function_name = "cw_resume_lambda"

  s3_bucket = "cw-cloud-resume-website"
  s3_key    = "lambda.zip"
  handler   = "lambda_code.lambda_handler"
  runtime   = "python3.12"

  role = aws_iam_role.lambda_role.arn

  depends_on = [
    aws_iam_role.lambda_role,
    aws_iam_role_policy_attachment.dynamodb_full_access,
    aws_iam_role_policy_attachment.lambda_basic_exec
  ]
}

# Links DynamoDb stream to my Lambda function
resource "aws_lambda_event_source_mapping" "dynamodb_to_lambda" {
  event_source_arn  = aws_dynamodb_table.cw_resume_dynamodb.stream_arn
  function_name     = aws_lambda_function.cw_resume_lambda.arn
  starting_position = "LATEST"
}

# Gives Lambda explicit permissions to be invoked by Api Gateway
resource "aws_lambda_permission" "api_gateway_to_lambda" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cw_resume_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.cw_resume_api.execution_arn}/*/*"
}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}




