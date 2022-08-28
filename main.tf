###IAM
module "iam" {
  source  = "./modules/iam"
}

### END IAM

###BASTION
module "bastion" {
  source = "./modules/bastion"
  key_name = "demo"
  ami = "ami-0959f8e18a2aac0fb"
  subnet_id = "subnet-032eb52f974061033"
  vpc_id = module.vpc.vpc_id
  environment = "prod-demo"
  availability_zone = var.availability_zones[0]
  project = var.project
}

### END BASTION

### VPC
resource "aws_eip" "nat" {
  count = length(var.availability_zones)
  vpc   = true
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  key          = "${data.aws_caller_identity.self.account_id}-${var.project}"
  cluster_name = "${local.key}-${random_string.suffix.result}"
  cert_manager_namespace = "cert-manager"

  common_tags = {
    Terraform = "true"
    Project   = var.project
  }

}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  # version = "2.6.0"

  name = "${local.key}-main"

  azs             = var.availability_zones
  cidr            = var.main_cidr
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway   = true
  enable_vpn_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = merge({ "kubernetes.io/cluster/${local.cluster_name}" = "shared" }, local.common_tags)

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
### VPC END
