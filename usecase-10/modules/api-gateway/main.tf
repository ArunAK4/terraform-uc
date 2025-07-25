resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = "API Gateway with Lambda Proxy Integration"
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "get" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  
  # to avoid 500 internal server error
  request_parameters = {
    "method.request.path.proxy" = true
  }

}

resource "aws_api_gateway_integration" "proxy_http" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.get.http_method
  integration_http_method = "ANY"
  type                    = "HTTP_PROXY"
  uri                     = "http://${var.uri}/{proxy}"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  depends_on = [
    aws_api_gateway_integration.proxy_http
  ]
}

resource "aws_api_gateway_stage" "stage" {
  rest_api_id        = aws_api_gateway_rest_api.api.id
  deployment_id      = aws_api_gateway_deployment.deployment.id
  stage_name         = var.stage_name
  description        = "Stage for proxy integration"
}
