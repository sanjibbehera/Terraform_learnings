provider "aws" {
  region = "ap-south-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${module.vpc.vpc_id}"
}

module "vpc" {

    source = "../../"

    name = "prod-vpc-provision-terraform"

  cidr = "10.40.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["10.40.1.0/24", "10.40.2.0/24", "10.40.3.0/24"]
  public_subnets  = ["10.40.101.0/24", "10.40.102.0/24", "10.40.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "terraform-provision-public-prod-subnet"
  }

  tags = {
    Owner       = "user"
    Environment = "prod"
  }

  vpc_tags = {
    Name = "vpc-prod-env"
  }
}