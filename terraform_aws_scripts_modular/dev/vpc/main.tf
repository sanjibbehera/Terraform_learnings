provider "aws" {
  region = "ap-south-1"
}

data "aws_security_group" "default" {
  name   = "default"
  vpc_id = "${module.vpc.vpc_id}"
}

module "vpc" {

    source = "../../"

    name = "dev-vpc-setup-terraform"

  cidr = "160.40.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["160.40.1.0/24", "160.40.2.0/24", "160.40.3.0/24"]
  public_subnets  = ["160.40.101.0/24", "160.40.102.0/24", "160.40.103.0/24"]

  enable_ipv6 = true

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    Name = "terraform-provision-public-dev-subnet"
  }

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-dev-name"
  }
}