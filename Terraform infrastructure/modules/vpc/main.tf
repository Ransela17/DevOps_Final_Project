resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support = var.enable_dns_support
  tags = { Name = "${var.environment}-vpc" }

}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.private_subnets, count.index)
  availability_zone = element(var.azs, count.index)
  count = length(compact(var.private_subnets))
  tags = { Name = "${var.environment}-private" }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(var.public_subnets, count.index)
  availability_zone = element(var.azs, count.index)
  count = length(compact(var.public_subnets))
  tags = { Name = "${var.environment}-public" }
  map_public_ip_on_launch = true
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "route-private" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = { Name = "route-public" }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_internet_gateway" "vpc" {
  vpc_id = aws_vpc.vpc.id
}

resource "aws_nat_gateway" "gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = element(aws_subnet.public.*.id, 0)

    depends_on = [ aws_internet_gateway.vpc ]
}

resource "aws_route_table_association" "private" {
  count = length(compact(var.private_subnets))
  subnet_id = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public" {
  count = length(compact(var.public_subnets))
  subnet_id = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "nat_gateway" {
  route_table_id = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.gw.id
}
resource "aws_route" "public_internet_gateway" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc.id
}