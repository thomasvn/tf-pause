################################################################################
# Terraform Setup
################################################################################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2.70"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-west-1"
}

################################################################################
# AWS Instance Configuration
################################################################################
# Ubuntu Server 20.04 LTS
resource "aws_instance" "PAUSE" {
  ami                         = "ami-00831fc7c1e3ddc60"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "PAUSE"
  }
}

# Amazon Linux 2 AMI
resource "aws_instance" "PAUSE2" {
  ami                         = "ami-03130878b60947df3"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "PAUSE2"
  }
}

# Red Hat Enterprise Linux 8
resource "aws_instance" "PAUSE3" {
  ami                         = "ami-09d9c5cdcfb8fc655"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  tags = {
    Name = "PAUSE3"
  }
}