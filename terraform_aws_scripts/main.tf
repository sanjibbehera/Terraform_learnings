variable "instance_name" {
  description = "terraform-rhelami-eg"
}

variable "region" {
  default = "eu-central-1"
}

variable "project_name" {
  default = "sanjibOracleRhel"
}

variable "shared_credentials_file" {
  default = "E:\\software_repo\\terraform_scripts\\creds.txt"
}

variable "profile" {
  default = "terraform"
}

variable "number_of_ebs" {}

resource "aws_security_group" "external" {
    name = "${var.project_name}_external"

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        self = true
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}


resource "aws_volume_attachment" "ebs_att" {
  count = var.number_of_ebs
  device_name = "/dev/sdh"
  volume_id   = "${element(aws_ebs_volume.newVolume.*.id, count.index)}"
  instance_id = "${element(aws_instance.example.*.id, count.index)}"
}

provider "aws" {
  region                  = var.region
  shared_credentials_file = var.shared_credentials_file
  profile                 = "terraform"
}

resource "aws_instance" "example" {
  count         = 5
  ami           = "ami-001e494dc0f3372bc"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.external.id}"]
  associate_public_ip_address = true
  key_name = "FrankfurtOracleLinuxKeyPair"
}

resource "aws_ebs_volume" "newVolume" {
  count = var.number_of_ebs
  availability_zone = "eu-central-1b"
  size              = 10
  type="standard"
  tags = {
    Name = var.project_name
  }
}
