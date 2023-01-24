variable "env" {
  description = "unique environment/stage name"
  default     = "prod"
  type        = string
}

variable "service" {
  description = "unique service name"
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

variable "allowed_aws_accounts_list" {
  description = "list of AWS accound IDs to allow connectivity to the VPC Endpoint (privatelink)"
  default     = []
}

locals {
  # consumer_vpc_name   = var.vpc_name == "" ? "consumer-${var.env}" : var.vpc_name
#   private_domain_name = "${local.provider_vpc_name}.${var.public_domain_name}"

  common_tags = {
    Environment = var.env
    Managed-By  = "terraform"
    VPC-Name    = var.vpc_name
  }
}
