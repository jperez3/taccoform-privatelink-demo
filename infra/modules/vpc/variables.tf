variable "env" {
  description = "unique environment/stage name"
  type        = string
}

variable "vpc_name_prefix" {
  description = "prefix for establishing uniqueness between VPCs in same account"
  default     = "main"
}

variable "vpc_name" {
  description = "overrides the default naming structure for VPC creation"
  default     = ""
}


locals {
  nat_instance_name = "nat-instance-${local.vpc_name}"
  vpc_name          = var.vpc_name != "" ? var.vpc_name : "${var.vpc_name_prefix}-${var.env}"

  common_tags = {
    environment = var.env
    managed-by  = "terraform"
    vpc-name    = local.vpc_name
  }
}
