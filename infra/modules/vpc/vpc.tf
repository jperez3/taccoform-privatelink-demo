#######
# VPC #
#######

resource "aws_vpc" "main" {
  cidr_block           = local.cidr_block
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.vpc_name}" })
  )
}



#########################
# Public VPC Networking #
#########################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "igw-${local.vpc_name}"
      "NetworkType" = "public"
    })
  )
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }


  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "public0-${local.vpc_name}"
      "NetworkType" = "public"
    })
  )
}

resource "aws_subnet" "public" {
  count = length(local.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.public_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "public${count.index}-${local.vpc_name}"
      "NetworkType" = "public"
    })
  )
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public[*].id)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}



##########################
# Private VPC Networking #
##########################

resource "aws_route_table" "private" {
  count = length(data.aws_availability_zones.available.names)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block           = "0.0.0.0/0"
    # network_interface_id = aws_instance.nat[count.index].primary_network_interface_id
    instance_id = aws_instance.nat[count.index].id
  }


  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "private${count.index}-${local.vpc_name}"
      "NetworkType" = "private"
    })
  )
}

resource "aws_subnet" "private" {
  count = length(local.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "private${count.index}-${local.vpc_name}"
      "NetworkType" = "private"
    })
  )
}

resource "aws_route_table_association" "private" {
  count = length(aws_subnet.private[*].id)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

###########
# Outputs #
###########

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "vpc_id" {
  value = aws_vpc.main.id
}


###############
# Privatelink #
###############

resource "aws_subnet" "privatelink" {
  count = var.enable_privatelink ? length(data.aws_availability_zones.available.names) : 0

  vpc_id            = aws_vpc.main.id
  cidr_block        = local.privatelink_subnets[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]


  tags = merge(
    local.common_tags,
    tomap({
      "Name"         = "privatelink${count.index}-${local.vpc_name}"
      "NetworkType" = "privatelink"
    })
  )
}

resource "aws_route_table_association" "privatelink" {
  count = var.enable_privatelink ? length(aws_subnet.privatelink[*].id) : 0

  subnet_id      = aws_subnet.privatelink[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}
