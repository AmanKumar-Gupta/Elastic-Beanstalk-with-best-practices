variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "default_tags" {
  description = "Default tags applied to all resources via provider"
  type        = map(string)
  default = {
    ManagedBy = "Terraform"
    Project   = "InfrastructureProject"
  }
}

variable "resource_tags" {
  description = "Additional tags applied to resources via modules"
  type        = map(string)
  default     = {}
}

# VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}


variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
}

# NAT Gateway
variable "single_nat_gateway" {
  description = "Whether to create only a single NAT Gateway (cost savings for non-prod)"
  type        = bool
  default     = false
}

# Database
variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_username" {
  description = "Username for the database"
  type        = string
  # Don't use 'admin' as it's a reserved word
}

variable "db_password" {
  description = "Password for the database"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "Port for the database"
  type        = number
  default     = 3306
  
}
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  
}

# Add these to your existing variables.tf

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for static assets"
  type        = string
}

variable "app_name" {
  description = "Name of the application"
  type        = string
}


variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "eb_solution_stack_name" {
  description = "Elastic Beanstalk solution stack name"
  type        = string
  default     = "64bit Amazon Linux 2 v5.10.0 running Node.js 18"
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

variable "alarm_emails" {
  description = "List of email addresses for alarm notifications"
  type        = list(string)
  default     = []
}

variable "eb_autoscaling_group_name" {
  description = "Name of the Elastic Beanstalk auto scaling group"
  type        = string
  # This might need to be obtained from the EB environment output
}

variable "eb_load_balancer_name" {
  description = "Name of the Elastic Beanstalk load balancer"
  type        = string
  # This might need to be obtained from the EB environment output
}