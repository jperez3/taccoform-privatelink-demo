variable "env" {
  description = "unique environment/stage name"
  default     = "prod"
  type        = string
}

variable "service" {
  description = "unique service name"
  type        = string
}

variable "vpc_name" {
  description = "VPC name for resource placement"
  default     = ""
  type        = string
}


locals {
  vpc_name = var.vpc_name == "" ? "consumer-${var.env}" : var.vpc_name

  common_tags = {
    Environment = var.env
    Managed-By  = "terraform"
    VPC-Name    = local.vpc_name
  }
}
