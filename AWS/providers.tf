# definir la version especifica de aws a utilizar
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # definir la region a utilizar
  access_key = var.access_key # definir la access key
  secret_key = var.secret_key # definir la secret key
}