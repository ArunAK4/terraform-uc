module "vpc" {
  source          = "./modules/vpc"
  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  azs             = var.azs
}

module "sg" {
  source      = "./modules/security-group"
  vpc_id      = module.vpc.vpc_id
  alb_sg_name = var.alb_sg_name
  nlb_sg_name = var.nlb_sg_name
  sg_name     = var.sg_name
}

module "nlb" {
  source             = "./modules/nlb"
  nlb_name           = "uc10-nlb"
  subnet_ids         = module.vpc.private_subnet_ids
  vpc_id             = module.vpc.vpc_id
  target_group_name  = "nlb-to-alb"
  nlb_sg_id          = module.sg.nlb_sg_id
}

module "alb" {
  source         = "./modules/alb"
  name           = "uc10-alb"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnet_ids
  alb_sg_id      = module.sg.alb_sg_id
}

module "ecs_cluster" {
  source             = "./modules/ecs"
  cluster_name       = var.cluster_name
  execution _role_arn = var.execution_role_arn
  task_arn_role      = var.execution_role_arn
  subnets            = module.vpc.private_subnet_ids
  security_groups    = [module.sg.sg_id]

  services = {
    appointments = {
      image            = var.appointment_repo_url
      cpu              = 256
      memory           = 512
      container_port   = 3001
      target_group_arn = module.alb.appointments_tg_arn
    }
    patients = {
      image            = var.patients_repo_url
      cpu              = 256
      memory           = 512
      container_port   = 3000
      target_group_arn = module.alb.patients_tg_arn
    }
  }
}

module "api_gateway" {
  source               = "./modules/api-gateway"
  api_name             = var.api_name
  stage_name           = "dev"
  resource_path        = "/{proxy+}"
  uri = module.alb.alb_dns_name
}