module "vpc" {
  source = "../../modules/vpc"

  for_each = {
    provider = {
      cidr_block         = "10.1.0.0/16"
      # enable_privatelink = true
      vpc_name           = "provider"
    },
    consumer = {
      cidr_block         = "10.2.0.0/16"
      # enable_privatelink = false
      vpc_name           = "consumer"

    }
  }

  cidr_block              = each.value.cidr_block
  env                     = "prod"
  enable_jumpbox_instance = true
  # enable_privatelink      = each.value.enable_privatelink
  vpc_name                = each.value.vpc_name
}

# av aws-connect -n jumpbox0-consumer -r us-east-2
