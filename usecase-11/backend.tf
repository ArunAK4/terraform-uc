terraform {
  backend "s3" {
    bucket       = "terraform-usecases-batch6"
    key          = "usecase11/terraform.tfstate"
    region       = "eu-west-1"
    use_lockfile = true
  }
}