
resource "aws_cognito_user_pool" "default" {
  name = "default-user-pool"
}

resource "aws_cognito_user_pool_client" "default" {
  name         = "default-client"
  user_pool_id = aws_cognito_user_pool.default.id

  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["email"]
  supported_identity_providers         = ["COGNITO"]
  callback_urls                        = [var.callback_url]
}

resource "aws_cognito_user_pool_domain" "default" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.default.id
}