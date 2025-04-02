# AWS Infrastructure Terraform Project

This Terraform project deploys a complete AWS infrastructure including VPC, NAT Gateway, RDS, and Security Groups.

## Architecture

The infrastructure includes:

- VPC with public and private subnets across multiple AZs
- Internet Gateway and NAT Gateway for outbound connectivity
- RDS PostgreSQL database in private subnets
- Security groups for application and database tiers

## Prerequisites

- Terraform >= 1.0.0
- AWS CLI configured with appropriate permissions
- S3 bucket and DynamoDB table for remote state (for production)

## Usage

1. Clone this repository
2. Navigate to the `root` directory
3. Initialize Terraform:
   ```
   terraform init
   ```
4. Review the execution plan:
   ```
   terraform plan
   ```
5. Apply the changes:
   ```
   terraform apply
   ```

## Environment Configuration

This project supports multiple environments (dev, staging, prod) through variable files:

- `terraform.tfvars` - Default configuration (dev environment)
- `staging.tfvars` - Staging environment configuration
- `prod.tfvars` - Production environment configuration

To use a specific environment configuration:

```
terraform apply -var-file=prod.tfvars
```

## Best Practices Implemented

- Modular architecture for reusability
- Resource tagging for cost allocation and management
- Multi-AZ deployment for high availability
- Security group rules limiting access to required services
- Encryption for data at rest
- Backup and maintenance scheduling
- Parameterized configuration for different environments

## Security Considerations

- Database placed in private subnets
- Security groups limited to required access
- KMS encryption for database
- Parameterized sensitive information (should use AWS Secrets Manager in production)

## Production Deployment

For production deployments:

1. Uncomment and configure the S3 backend in `versions.tf`
2. Set `single_nat_gateway = false` for high availability
3. Set `db_multi_az = true` for database high availability
4. Set `db_deletion_protection = true` to prevent accidental deletion
5. Set `skip_final_snapshot = false` to ensure final backups
6. Use AWS Secrets Manager for database credentials