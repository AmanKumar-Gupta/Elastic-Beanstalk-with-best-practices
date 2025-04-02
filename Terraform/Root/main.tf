# Configure AWS provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = var.default_tags
  }
}

# Create VPC with subnets, IGW, and route tables
module "vpc" {
  source = "../modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  environment          = var.environment
  tags                 = var.resource_tags
}

# Create NAT Gateways for private subnet internet access
module "nat" {
  source = "../modules/nat"

  environment           = var.environment
  public_subnet_ids     = module.vpc.public_subnet_ids
  private_route_table_ids = module.vpc.private_route_table_ids
  single_nat_gateway    = var.single_nat_gateway
  igw_id                = module.vpc.igw_id
  tags                  = var.resource_tags

  # Ensure VPC is created before NAT
  depends_on = [module.vpc]
}

# Create security groups
module "app_security_group" {
  source = "../modules/security_group"

  environment  = var.environment
  name         = "app-sg"
  description  = "Security group for application servers"
  vpc_id       = module.vpc.vpc_id
  
  # Allow HTTP/HTTPS from anywhere
  ingress_cidr_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTP from anywhere"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow HTTPS from anywhere"
    }
  ]
  
  # Allow all outbound by default
  allow_all_outbound = true
  tags               = var.resource_tags

  depends_on = [module.vpc]
}

module "db_security_group" {
  source = "../modules/security_group"

  environment  = var.environment
  name         = "db-sg"
  description  = "Security group for RDS database"
  vpc_id       = module.vpc.vpc_id
  
  # Allow database access only from application security group
  ingress_sg_rules = [
    {
      from_port                = var.db_port
      to_port                  = var.db_port
      protocol                 = "tcp"
      source_security_group_id = module.app_security_group.security_group_id
      description              = "Allow database access from application servers"
    }
  ]
  
  # Allow all outbound by default
  allow_all_outbound = true
  tags               = var.resource_tags

  depends_on = [module.vpc, module.app_security_group]
}

# Create RDS instance in private subnets
# Replace your existing database module with this:
module "database" {
  source = "../modules/rds"

  project_name    = var.project_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  vpc_cidr  = module.vpc.vpc_cidr
  private_subnets = module.vpc.private_subnet_ids
  
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  # Remove any parameters not needed in the new module
}

# You can remove the db_security_group module since it's now created in the RDS module
# Existing modules (vpc, nat, rds, security_group)
# ...

module "s3" {
  source = "../modules/s3"

  bucket_name        = var.s3_bucket_name
  enable_versioning  = true
  enable_cors        = true
  cors_allowed_methods = ["GET", "PUT", "POST", "HEAD"]
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "elastic_beanstalk" {
  source = "../modules/elastic_beanstalk"

  application_name        = var.app_name
  application_description = "${var.app_name} e-commerce application"
  environment_name        = "${var.app_name}-${var.environment}"
  solution_stack_name     = var.eb_solution_stack_name
  
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id = module.app_security_group.security_group_id
  
  db_endpoint = module.database.db_instance_endpoint
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
  
  s3_bucket_name = module.s3.bucket_id
  
  min_instances = var.min_instances
  max_instances = var.max_instances
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

module "monitoring" {
  source = "../modules/monitoring"

  app_name         = var.app_name
  environment_name = "${var.app_name}-${var.environment}"
  aws_region       = var.aws_region
  
  alarm_topic_name      = "${var.app_name}-alarms"
  alarm_email_endpoints = var.alarm_emails
  
  eb_autoscaling_group_name = var.eb_autoscaling_group_name # This might need to be dynamically obtained
  eb_load_balancer_name     = var.eb_load_balancer_name     # This might need to be dynamically obtained
  rds_identifier            = module.database.db_instance_id

  
  eb_cpu_threshold         = 80
  eb_latency_threshold     = 1
  rds_cpu_threshold        = 80
  rds_free_storage_threshold = 5000000000  # 5 GB
  
  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}