# started with:
# https://github.com/aws-ia/terraform-aws-eks-blueprints/blob/main/patterns/private-public-ingress/main.tf
data "aws_availability_zones" "available" {
  # Do not include local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

locals {
  name   = "hashy"
  region = "us-east-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 2)

  tags = {
    Blueprint  = local.name
    GithubRepo = "github.com/aws-ia/terraform-aws-eks-blueprints"
  }
}

module "app" {
  source              = "./modules/app"
  name                = local.name
  vpc_id              = module.app-vpc.vpc_id
  vpc_cider_block     = local.vpc_cidr
  vpc_private_subnets = module.app-vpc.private_subnets
  tags                = local.tags
}

module "app-vpc" {
  source   = "./modules/vpc"
  name     = local.name
  tags     = local.tags
  azs      = local.azs
  vpc_cidr = local.vpc_cidr
}

module "app-eks" {
  source              = "./modules/eks"
  name                = local.name
  tags                = local.tags
  vpc_id              = module.app-vpc.vpc_id
  vpc_private_subnets = module.app-vpc.private_subnets
  vpc_cider_block     = local.vpc_cidr
}
