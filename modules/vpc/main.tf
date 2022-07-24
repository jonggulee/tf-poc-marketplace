resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = merge(var.tags, tomap({ "Name" = format("%s-vpc", var.name) }))
}

resource "aws_subnet" "pub" {
  count = length(var.public_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, tomap({ "Name" = format("%s-pub-%s", var.name, substr(var.azs[count.index], -2, -1)) }))
}

resource "aws_subnet" "pri" {
  count = length(var.private_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, tomap({ "Name" = format("%s-pri-%s", var.name, substr(var.azs[count.index], -2, -1)) }))
}

resource "aws_subnet" "res" {
  count = length(var.restricted_subnets)

  vpc_id            = aws_vpc.main.id
  cidr_block        = var.restricted_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(var.tags, tomap({ "Name" = format("%s-res-%s", var.name, substr(var.azs[count.index], -2, -1)) }))
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, tomap({ "Name" = format("%s-vpc-igw", var.name) }))
}

# NAT Gateway EIP
resource "aws_eip" "nat" {
  count = 1
  vpc   = true

  tags = merge(var.tags, tomap({ "Name" = format("%s-nat-eip-%s", var.name, substr(var.azs[count.index], -2, -1)) }))
}

# NAT Gateway
resource "aws_nat_gateway" "natgw" {
  count = 1

  subnet_id     = aws_subnet.pub.*.id[0]
  allocation_id = aws_eip.nat.*.id[0]

  tags = merge(var.tags, tomap({ "Name" = format("%s-vpc-nat-%s", var.name, substr(var.azs[count.index], -2, -1))}))

  depends_on = [aws_internet_gateway.igw]
}

# # Route tables
resource "aws_route_table" "pub" {
  count = 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, tomap({ "Name" = format("%s-pub-rt", var.name)}))
}

resource "aws_route_table" "pri" {
  count = 1
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.*.id[0]
  }
  tags = merge(var.tags, tomap({ "Name" = format("%s-pri-rt", var.name)}))

    lifecycle {
        ignore_changes = all
  }
}

resource "aws_route_table" "res" {
  count = 1
  vpc_id = aws_vpc.main.id

  tags = merge(var.tags, tomap({ "Name" = format("%s-res-rt", var.name)}))
}

# Route Tables association
resource "aws_route_table_association" "pub" {
  count = length(var.public_subnets)

  subnet_id      = aws_subnet.pub.*.id[count.index]
  route_table_id = aws_route_table.pub.*.id[0]
}

resource "aws_route_table_association" "pri" {
  count = length(var.private_subnets)

  subnet_id      = aws_subnet.pri.*.id[count.index]
  route_table_id = aws_route_table.pri.*.id[0]
}

resource "aws_route_table_association" "res" {
  count = length(var.restricted_subnets)

  subnet_id      = aws_subnet.res.*.id[count.index]
  route_table_id = aws_route_table.res.*.id[0]
}