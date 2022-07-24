# VPC
output "vpc" {
  value       = module.vpc.vpc_cidr_block
  description = "The name of vpc"
}

output "public_subnet_cidr" {
    value   = module.vpc.public_subnets_cidr
    description = "The name of vpc"
}

output "private_subnet_cidr" {
    value   = module.vpc.private_subnets_cidr
}

output "restricted_subnet_cidr" {
    value   = module.vpc.restricted_subnets_cidr
}

output "nat_public_ips" {
    value   = module.vpc.nat_public_ips
}