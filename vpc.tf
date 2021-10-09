data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"

  name                 = var.vpc_name
  cidr                 = var.cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_nat_gateway   = true
  single_nat_gateway   = true
  one_nat_gateway_per_az = false
  enable_dns_hostnames = true
  enable_dns_support     = true

  tags = {
    "${var.cluster_name}" = "shared"
  }

  public_subnet_tags = {
    "${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    "${var.cluster_name}" = "shared"
  }
}
