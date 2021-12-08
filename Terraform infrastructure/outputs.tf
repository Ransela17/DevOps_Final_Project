output "environment" {
  value = var.environment
}

output "region" {
  value = var.region
}

// -------- VPC --------- //
output "vpc_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

// -------- LoadBalancer --------- //
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}
