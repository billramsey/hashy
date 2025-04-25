# Image Repository.
resource "aws_ecr_repository" "ecr_repo" {
  name                 = var.name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = var.tags
}

module "app-cache" {
  source              = "../cache"
  vpc_id              = var.vpc_id
  vpc_cider_block     = var.vpc_cider_block
  vpc_private_subnets = var.vpc_private_subnets
  tags                = var.tags
}


