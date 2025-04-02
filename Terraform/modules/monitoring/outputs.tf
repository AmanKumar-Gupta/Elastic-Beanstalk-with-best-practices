output "alarm_topic_arn" {
  description = "ARN of the SNS topic for alarms"
  value       = aws_sns_topic.alarms.arn
}

output "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  value       = aws_cloudwatch_dashboard.main.dashboard_name
}

output "log_group_app" {
  description = "Name of the application log group"
  value       = aws_cloudwatch_log_group.eb_app.name
}

output "log_group_nginx" {
  description = "Name of the nginx log group"
  value       = aws_cloudwatch_log_group.eb_nginx.name
}