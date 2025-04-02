# General
aws_region   = "us-east-1"
environment  = "dev"
resource_tags = {
  Owner       = "InfraTeam"
  CostCenter  = "10001"
  Application = "WebApp"
}

# VPC
vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
availability_zones   = ["us-east-1a", "us-east-1b"]

# NAT Gateway
single_nat_gateway  = true  # Set to false for production

# Database
db_username             = "dbadmin"
db_password             = "aman1234"  # Use AWS Secrets Manager in production
db_name                 = "appuser"
db_port                 = 3306

# Elastic Beanstalk
s3_bucket_name = "prod-static-assets-yourcompany-xyz123t"  # S3 bucket for static assets
app_name = "my-app"  # Application name
project_name = "ElasticBeanstalkProject"  # Project name
eb_solution_stack_name = "64bit Amazon Linux 2 v5.10.0 running Node.js 18"  # Solution stack name
min_instances = 2  # Minimum number of EC2 instances
max_instances = 4  # Maximum number of EC2 instances
alarm_emails = ["alerts@example.com"]  # Email addresses for alarm notifications
eb_autoscaling_group_name = "prod-eb-asg"  # Auto Scaling Group name
eb_load_balancer_name = "prod-eb-lb"  # Load Balancer name
