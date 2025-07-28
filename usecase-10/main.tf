

module "cognito" {
  source         = "./modules/cognito"
  callback_url   = "https://3b5ugx8tla.execute-api.ap-south-1.amazonaws.com/dev"
}
