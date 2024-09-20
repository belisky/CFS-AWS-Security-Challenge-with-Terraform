provider "aws" {
  region  = "us-west-2"
   
  default_tags {
    tags = {
       
      created-by = "terraform"       
      "environment" = var.environment_name
    }
  }  
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.46"
    }
  }
}