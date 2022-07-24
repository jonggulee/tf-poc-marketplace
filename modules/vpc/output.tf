# VPC
output "vpc_cidr_block" {
  description = "VPC에 할당한 CIDR block"
  value       = aws_vpc.main.cidr_block
}

# subnets
output "public_subnets_cidr" {
  description = "Public Subnet CIDR"
  value       = ["${aws_subnet.pub.*.cidr_block}"]
}

output "private_subnets_cidr" {
  description = "Private Subnet CIDR"
  value       = ["${aws_subnet.pri.*.cidr_block}"]
}

output "restricted_subnets_cidr" {
  description = "Restricted Subnet CIDR"
  value       = ["${aws_subnet.res.*.cidr_block}"]
}

# NAT 
output "nat_public_ips" {
  description = "NAT Gateway에 할당된 EIP 리스트"
  value       = ["${aws_eip.nat.*.public_ip}"]
}