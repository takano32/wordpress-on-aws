module "vpc" {
  # https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest
  source                 = "terraform-aws-modules/vpc/aws"
  version                = "~>5.0"
  name                   = "${var.prefix}-${var.environment}"
  cidr                   = var.vpc_cidr
  azs                    = data.aws_availability_zones.this.names
  private_subnets        = var.private_subnet_cidrs
  public_subnets         = var.public_subnet_cidrs
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = false
  tags                   = var.tags
  enable_dns_hostnames   = true
}
