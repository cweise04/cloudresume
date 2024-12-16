# Crates the REST API Gateway rest api Resource with its name
resource "aws_api_gateway_rest_api" "cw_resume_api" {
  name = "cw_resume_api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
  disable_execute_api_endpoint = true
}

# Creates the count resource and path in the API Gateway
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  parent_id   = aws_api_gateway_rest_api.cw_resume_api.root_resource_id
  path_part   = "count"
}

# Creates the POST method for the prod stage
resource "aws_api_gateway_method" "post_method" {
  rest_api_id   = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "POST"
  authorization = "NONE"
}

# Creates the POST method response with CORS handling
resource "aws_api_gateway_method_response" "post_response" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.post_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = true
    "method.response.header.Access-Control-Allow-Methods"  = true
    "method.response.header.Access-Control-Allow-Origin" = true
  }
}

# Configures the Lambda Proxy Integration for the POST method, which allows Lambda to handle the entire HTTP request and response.
resource "aws_api_gateway_integration" "integration_lambda_proxy" {
  rest_api_id             = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.post_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cw_resume_lambda.invoke_arn
}

# Creates the OPTIONS method for CORS preflight requests
resource "aws_api_gateway_method" "options_method" {
  rest_api_id   = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

# Creates the OPTIONS method response for CORS
resource "aws_api_gateway_method_response" "options_response" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = "200"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = true
    "method.response.header.Access-Control-Allow-Methods"  = true
    "method.response.header.Access-Control-Allow-Origin"   = true
  }
}

# Configures the OPTIONS integration
resource "aws_api_gateway_integration" "options_integration" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  type        = "MOCK"

  request_templates = {
    "application/json" = jsonencode({
      statusCode = 200
    })
  }
}

# Defines the OPTIONS integration response with CORS headers
resource "aws_api_gateway_integration_response" "options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  resource_id = aws_api_gateway_resource.api_resource.id
  http_method = aws_api_gateway_method.options_method.http_method
  status_code = aws_api_gateway_method_response.options_response.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers"  = "'Content-Type,X-Amz-Date,Authorization,X-API-Key'"
    "method.response.header.Access-Control-Allow-Methods"  = "'OPTIONS,POST'"
    "method.response.header.Access-Control-Allow-Origin"   = "'*'"
  }
}

# Configures API Gateway to handle 4xx error responses and enables CORS
resource "aws_api_gateway_gateway_response" "response_4xx" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  response_type = "DEFAULT_4XX"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# Configures API Gateway to handle 5xx error responses and enables CORS
resource "aws_api_gateway_gateway_response" "response_5xx" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id
  response_type = "DEFAULT_5XX"
  response_templates = {
    "application/json" = "{'message':$context.error.messageString}"
  }
  response_parameters = {
    "gatewayresponse.header.Access-Control-Allow-Origin" = "'*'"
  }
}

# Creates a deployment for the API Gateway, ensuring that changes to specific components trigger redeployment
resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.cw_resume_api.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_resource.id,
      aws_api_gateway_method.post_method.id,
      aws_api_gateway_integration.integration_lambda_proxy.id,
      aws_api_gateway_method.options_method.id
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Creates the prod stage for deployment
resource "aws_api_gateway_stage" "api_prod_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.cw_resume_api.id
  stage_name    = "prod"
}

# Lambda permissions to allow API Gateway to invoke Lambda function
resource "aws_lambda_permission" "allow_apigateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cw_resume_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.cw_resume_api.execution_arn
}
