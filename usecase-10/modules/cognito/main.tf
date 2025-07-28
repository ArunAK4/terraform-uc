
resource "aws_cognito_user_pool" "default" {
  name = "default-user-pool"
}


resource "aws_cognito_user_pool_domain" "default" {
  domain       = var.domain_prefix
  user_pool_id = aws_cognito_user_pool.default.id
}