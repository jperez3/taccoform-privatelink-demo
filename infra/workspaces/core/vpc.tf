module "vpc" {
  source = "../../modules/vpc"

  for_each = var.vpcs

  env                     = "prod"
  enable_jumpbox_instance = true
  vpc_name                = each.value.vpc_name
}


variable "vpcs" {
  default = {
    provider = {
      vpc_name = "provider-vpc"
    },
    consumer = {
      vpc_name = "consumer-vpc"
    }
  }
}
