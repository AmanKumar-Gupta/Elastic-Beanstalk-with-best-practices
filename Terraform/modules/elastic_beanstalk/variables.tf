variable "application_name" {
  description = "Name of the Elastic Beanstalk application"
  type        = string
}

variable "application_description" {
  description = "Description of the Elastic Beanstalk application"
  type        = string
  default     = "E-commerce application"
}

variable "environment_name" {
  description = "Name of the Elastic Beanstalk environment"
  type        = string
}

variable "solution_stack_name" {
  description = "Solution stack name for the Elastic Beanstalk environment"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "ID of the security group for Elastic Beanstalk instances"
  type        = string
}

variable "db_endpoint" {
  description = "RDS database endpoint"
  type        = string
}

variable "db_name" {
  description = "RDS database name"
  type        = string
}

variable "db_username" {
  description = "RDS database username"
  type        = string
}

variable "db_password" {
  description = "RDS database password"
  type        = string
  sensitive   = true
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  type        = string
}

variable "min_instances" {
  description = "Minimum number of EC2 instances"
  type        = number
  default     = 2
}

variable "max_instances" {
  description = "Maximum number of EC2 instances"
  type        = number
  default     = 4
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}