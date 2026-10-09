provider "aws" {
  region = "us-east-1" # Change if you are using a different region
}

# 1. Fetch your AWS Account's Default VPC
data "aws_vpc" "default" {
  default = true
}

# 2. Fetch subnets, explicitly excluding unsupported EKS zones (like us-east-1e)
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1f"]
  }
}

# 3. Create the EKS Cluster
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "free-tier-cluster"
  cluster_version = "1.36"

  vpc_id     = data.aws_vpc.default.id
  subnet_ids = data.aws_subnets.default.ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # FIX: Automatically grant admin permissions to the IAM identity running Terraform
  enable_cluster_creator_admin_permissions = true

  # 4. Worker Nodes using c7i-flex.large instances
  eks_managed_node_groups = {
    free_tier_nodes = {
      min_size     = 2
      max_size     = 4
      desired_size = 2

      instance_types = ["c7i-flex.large"]
      capacity_type  = "ON_DEMAND"
    }
  }
}

# 5. Allow Default VPC traffic to reach cluster control plane
resource "aws_security_group_rule" "allow_vpc_to_cluster" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = module.eks.cluster_security_group_id
  cidr_blocks       = [data.aws_vpc.default.cidr_block]
}
