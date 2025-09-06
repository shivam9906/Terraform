# Configure the AWS provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "<provider_name>"
    }
  }
  }

provider "aws" {
  region = "<region_name>"
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "<ami_name>"
  instance_type = "<instance_type_name>"
}