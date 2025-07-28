variable "user_pool_name" {
  description = "Name of the Cognito User Pool"
  type        = string
}

variable "callback_url" {
  description = "Callback URL for the Cognito User Pool Client"
  type        = string
}
