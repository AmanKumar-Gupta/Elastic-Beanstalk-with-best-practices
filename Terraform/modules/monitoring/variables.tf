variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment_name" {
  description = "Name of the environment"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "alarm_topic_name" {
  description = "Name of the SNS topic for alarms"
  type        = string
  default     = "application-alarms"
}

variable "alarm_email_endpoints" {
  description = "List of email addresses to receive alarm notifications"
  type        = list(string)
  default     = []
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}

variable "eb_autoscaling_group_name" {
  description = "Name of the Elastic Beanstalk auto scaling group"
  type        = string
}

variable "eb_load_balancer_name" {
  description = "Name of the Elastic Beanstalk load balancer"
  type        = string
}

variable "rds_identifier" {
  description = "Identifier of the RDS instance"
  type        = string
}

variable "eb_cpu_threshold" {
  description = "Threshold for Elastic Beanstalk CPU alarm"
  type        = number
  default     = 80
}

variable "eb_latency_threshold" {
  description = "Threshold for Elastic Beanstalk latency alarm in seconds"
  type        = number
  default     = 1
}

variable "rds_cpu_threshold" {
  description = "Threshold for RDS CPU alarm"
  type        = number
  default     = 80
}

variable "rds_free_storage_threshold" {
  description = "Threshold for RDS free storage alarm in bytes"
  type        = number
  default     = 5000000000  # 5 GB
}

variable "rds_connections_threshold" {
  description = "Threshold for RDS connections alarm"
  type        = number
  default     = 100
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}