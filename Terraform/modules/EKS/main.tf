module "vpc" {
  source = "./modules/vpc"
  name   = var.project_name
}

# Get your current public IP
data "http" "myip" {
  url = "https://checkip.amazonaws.com/"
}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "innovatemart-eks"
  cluster_version = "1.32"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  # API endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = [
    "0.0.0.0/0"
  ]


  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
    }
  }

  # Map your IAM user to cluster-admin
  aws_auth_users = [
    {
      userarn  = "arn:aws:iam::159431052044:user/kergs-admin"
      username = "kergs-admin"
      groups   = ["system:masters"]
    },
    
    {
      userarn  = "arn:aws:iam::159431052044:user/${var.dev_user_name}"
      username = var.dev_user_name
      groups   = ["dev-readonly"]   
    }
  ]
  

}
