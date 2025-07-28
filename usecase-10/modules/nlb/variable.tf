variable "nlb_name" {
  type        = string
  description = "Name of the Network Load Balancer"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the NLB"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for the target group"
}

variable "target_group_name" {
  type        = string
  description = "Name of the target group"
}