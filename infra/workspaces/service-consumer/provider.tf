terraform {
  backend "remote" {
    organization = "ordisius"

    workspaces {
      name = "taccoform-privatelink-consumer"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}


provider "aws" {
  region = "us-east-2"

 default_tags {
   tags = {
     Environment = "prod"
   }
 }
}
