
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.11"

  cluster_name                   = var.name
  cluster_version                = "1.32"
  # Turn this back to true to do additional work
  cluster_endpoint_public_access = false

  # Give the Terraform identity admin access to the cluster
  # which will allow resources to be deployed into the cluster
  enable_cluster_creator_admin_permissions = true

  vpc_id     = var.vpc_id
  subnet_ids = var.vpc_private_subnets

  eks_managed_node_groups = {
    core_node_group = {
      instance_types = ["t2.small"]

      ami_type = "BOTTLEROCKET_x86_64"
      platform = "bottlerocket"

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }
  tags = var.tags
}

module "eks_blueprints_addons" {
  source  = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.16"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  enable_aws_load_balancer_controller = true

  aws_load_balancer_controller = {
    chart_version = "1.6.0" # min version required to use SG for NLB feature
    set = [
      {
        name  = "vpcId"
        value = var.vpc_id
      },
      {
        name  = "enableServiceMutatorWebhook" # Otherwise, it makes an nlb, which is internal.
        value = "false"
      }
    ]
  }

  tags = var.tags
}
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      # This requires the awscli to be installed locally where Terraform is executed
      args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}
