terraform {
  backend "remote" {
    organization = "ordisius"

    workspaces {
      name = "taccoform-privatelink-tostada"
    }
  }
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 4.2.0"
    }
  }
}


provider "aws" {
  region = "us-east-2"
}
