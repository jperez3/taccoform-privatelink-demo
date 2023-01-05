variable "cidr_block" {
  description = "the CIDR block for VPC to use"
  default     = ""
  type        = string
}

variable "enable_privatelink" {
  description = "enables/disables privatelink subnet creation"
  default     = false
}


locals {
  nat_instance_name = "nat-instance-${local.vpc_name}"
  vpc_name          = var.vpc_name != "" ? var.vpc_name : "${var.vpc_name_prefix}-${var.env}"

  # Creates a 10.x.0.0/16 CIDR block if one isn't provided
  cidr_block = var.cidr_block != "" ? var.cidr_block : "10.123.0.0/16"

  # spliting the user provided CIDR block into three /24 private subnets and three /24 public subnets
  cidr_split      = flatten(cidrsubnets(local.cidr_block, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8, 8))
  public_subnets  = slice(local.cidr_split, 0, 3)
  private_subnets = slice(local.cidr_split, 3, 6)

  privatelink_subnets = slice(local.cidr_split, 6, 12)
}
