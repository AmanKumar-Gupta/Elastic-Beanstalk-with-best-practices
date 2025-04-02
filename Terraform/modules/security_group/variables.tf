variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "name" {
  description = "Name of the security group"
  type        = string
}

variable "description" {
  description = "Description of the security group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "ingress_cidr_rules" {
  description = "List of ingress rules to create with CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = []
}

variable "ingress_sg_rules" {
  description = "List of ingress rules to create with source security groups"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string)
  }))
  default = []
}

variable "egress_cidr_rules" {
  description = "List of egress rules to create with CIDR blocks"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = []
}

variable "egress_sg_rules" {
  description = "List of egress rules to create with destination security groups"
  type = list(object({
    from_port                = number
    to_port                  = number
    protocol                 = string
    source_security_group_id = string
    description              = optional(string)
  }))
  default = []
}

variable "allow_all_outbound" {
  description = "Whether to add a rule allowing all outbound traffic"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}
