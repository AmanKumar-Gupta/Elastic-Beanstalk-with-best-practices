variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs where NAT Gateways will be deployed"
  type        = list(string)
}

variable "private_route_table_ids" {
  description = "List of private route table IDs to add NAT Gateway routes"
  type        = list(string)
}

variable "single_nat_gateway" {
  description = "Whether to create only a single NAT Gateway (cost savings for non-prod)"
  type        = bool
  default     = false
}

variable "igw_id" {
  description = "The ID of the Internet Gateway the NAT Gateway depends on"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
