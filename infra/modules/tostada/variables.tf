variable "env" {
  description = "unique environment/stage name"
  default     = "prod"
  type        = string
}

variable "public_domain_name" {
    description = "domain name used for certificate creation"
    default     = "tacoform.com"
    type        = string
}

variable "vpc_name" {
  description = "VPC name for resource placement"
  default     = ""
  type        = string
}

locals {
  vpc_name = var.vpc_name == "" ? "provider-${var.env}" : var.vpc_name
  private_domain_name = "${local.vpc_name}.${var.public_domain_name}"

  common_tags = {
    Environment = var.env
    Managed-By  = "terraform"
    VPC-Name    = local.vpc_name
  }
}
