output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.nat[*].id
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for the NAT Gateways"
  value       = aws_eip.nat[*].public_ip
}