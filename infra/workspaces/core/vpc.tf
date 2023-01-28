module "vpc" {
  source = "../../modules/vpc"

  for_each = {
    provider = {
      cidr_block         = "10.1.0.0/16"
      vpc_name           = "provider-prod"
    },
    consumer = {
      cidr_block         = "10.2.0.0/16"
      vpc_name           = "consumer-prod"

    }
  }

  cidr_block              = each.value.cidr_block
  env                     = "prod"
  enable_jumpbox_instance = true
  vpc_name                = each.value.vpc_name
}
