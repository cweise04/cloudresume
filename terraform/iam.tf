

# Allow Lambda to assume role
resource "aws_iam_role" "lambda_role" {
  name = "cwcloudresume_lambda_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : "sts:AssumeRole"
        Effect : "Allow"
        Principal : {
          Service : "lambda.amazonaws.com"
        }
      }
    ]
  })

}

# Attach a DynamoDB full access policy to the iam role
resource "aws_iam_role_policy_attachment" "dynamodb_full_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"

  depends_on = [aws_iam_role.lambda_role]
}

# Attach a basic Lambda policy to the iam role
resource "aws_iam_role_policy_attachment" "lambda_basic_exec" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

  depends_on = [aws_iam_role.lambda_role]
}


# Output the role so that Lambda can use the permissions from the role
output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

