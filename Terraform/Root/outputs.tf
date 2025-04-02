output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_cidr" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = module.nat.nat_gateway_ids
}

output "nat_gateway_public_ips" {
  description = "List of public Elastic IPs created for the NAT Gateways"
  value       = module.nat.nat_gateway_public_ips
}

output "app_security_group_id" {
  description = "ID of the application security group"
  value       = module.app_security_group.security_group_id
}

output "db_security_group_id" {
  description = "ID of the database security group"
  value       = module.db_security_group.security_group_id
}

output "db_instance_endpoint" {
  description = "Connection endpoint of the RDS instance"
  value       = module.database.db_instance_endpoint
}

output "db_instance_id" {
  description = "ID of the RDS instance"
  value       = module.database.db_instance_id
}

# Add these to your existing outputs.tf

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_id
}

output "s3_bucket_domain_name" {
  description = "Domain name of the S3 bucket"
  value       = module.s3.bucket_domain_name
}

output "eb_application_name" {
  description = "Name of the Elastic Beanstalk application"
  value       = module.elastic_beanstalk.application_name
}

output "eb_environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk.environment_name
}

output "eb_environment_endpoint" {
  description = "Endpoint URL of the Elastic Beanstalk environment"
  value       = module.elastic_beanstalk.environment_endpoint
}

output "cloudwatch_dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = module.monitoring.dashboard_name
}
