output "environment" {
  value = var.environment
}

output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "cidr_block_public" {
  value = [ aws_subnet.public.*.cidr_block ]
}

output "private_subnets" {
  value = [ aws_subnet.private.*.id ]
}

output "public_subnets" {
  value = [ aws_subnet.public.*.id ]
}
