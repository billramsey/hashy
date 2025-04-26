# Redis
module "elasticache" {
  source = "terraform-aws-modules/elasticache/aws"

  cluster_id               = "hashy-redis"
  create_cluster           = true
  create_replication_group = false

  engine_version = "7.1"
  node_type      = "cache.t2.micro"

  maintenance_window = "sun:05:00-sun:09:00"
  apply_immediately  = true

  # Security group
  vpc_id = var.vpc_id
  security_group_rules = {
    ingress_vpc = {
      # Default type is `ingress`
      # Default port is based on the default engine port
      description = "VPC traffic"
      cidr_ipv4   = var.vpc_cider_block
    }
  }
  # Subnet Group
  subnet_ids = var.vpc_private_subnets
  tags       = var.tags
}