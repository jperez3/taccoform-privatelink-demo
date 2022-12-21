variable "cidr_block" {
  description = "the CIDR block for VPC to use"
  default     = ""
  type        = string
}


locals {
  # Creates a 10.x.0.0/16 CIDR block if one isn't provided
  cidr_block = var.cidr_block != "" ? var.cidr_block : "10.123.0.0/16"

  # spliting the user provided CIDR block into three /20 private subnets and three /20 public subnets
  cidr_split      = flatten(cidrsubnets(local.cidr_block, 4, 4, 4, 4, 4, 4))
  private_subnets = slice(local.cidr_split, 0, 3)
  public_subnets  = slice(local.cidr_split, 3, 6)
}
