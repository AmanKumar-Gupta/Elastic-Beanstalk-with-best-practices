# General AWS Settings
aws_region  = "us-east-1"
environment = "dev"
project_name = "eCommercePlatform"

default_tags = {
  ManagedBy = "Terraform"
  Project   = "InfrastructureProject"
}

resource_tags = {
  Owner       = "InfraTeam"
  CostCenter  = "10001"
  Application = "WebApp"
}

# VPC Configuration
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# NAT Gateway
single_nat_gateway = true  # Set to false for production

# Database Configuration
db_name     = "appdb"
db_username = "dbadmin"
db_password = "ChangeMe123!"  # Use AWS Secrets Manager in production
db_port     = 3306

# S3 Storage
s3_bucket_name = "dev-static-assets-ecommerce-xyz123"  # Must be globally unique

# Elastic Beanstalk Configuration
app_name = "ecommerce-app"
eb_solution_stack_name = "64bit Amazon Linux 2 v5.10.0 running Node.js 18"
min_instances = 2
max_instances = 4

# Monitoring and Alerting
alarm_emails = ["devops@example.com", "alerts@example.com"]

eb_autoscaling_group_name = "prod-eb-asg"  # Auto Scaling Group name
eb_load_balancer_name = "prod-eb-lb"  # Load Balancer name