resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, { Name = "${var.environment}-vpc" })
}


resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidrs)
  vpc_id   = aws_vpc.main.id
  cidr_block = each.value
  map_public_ip_on_launch = true
  tags = merge(var.tags, { Name = "Public-Subnet-${each.key}" })
}
  

resource "aws_subnet" "private" {
  for_each = toset(var.private_subnet_cidrs)

  vpc_id     = aws_vpc.main.id
  cidr_block = each.value
  availability_zone = "us-west-2a"  
  tags = merge(var.tags, { Name = "Private-Subnet-${each.key}" })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "InternetGateway" })
}

resource "aws_nat_gateway" "private_nat" {
  connectivity_type = "private"
  subnet_id         = element(values(aws_subnet.public), 0).id
  tags              = merge(var.tags, { Name = "PrivateNATGateway" })
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = merge(var.tags, { Name = "PublicRouteTable" })
}

resource "aws_route_table_association" "public_association" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.private_nat.id
  }

  tags = merge(var.tags, { Name = "PrivateRouteTable" })
}

resource "aws_route_table_association" "private_association" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}
