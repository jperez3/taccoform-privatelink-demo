variable "env" {
  description = "unique environment/stage name"
  default     = "prod"
  type        = string
}

variable "public_domain_name" {
    description = "domain name used for certificate creation"
    default     = "tacoform.com"
}

locals {
  vpc_name = "provider-prod"
  common_tags = {
    Environment = var.env
    Managed-By  = "terraform"
    VPC-Name    = local.vpc_name
  }
}
