

module "cognito" {
  source         = "./modules/cognito"
  user_pool_name = "my-simple-user-pool"
  callback_url   = "https://3b5ugx8tla.execute-api.ap-south-1.amazonaws.com/dev"
  domain_prefix = "usecase10"
}
