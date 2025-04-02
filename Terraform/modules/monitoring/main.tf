# SNS Topic for Alarms
resource "aws_sns_topic" "alarms" {
  name = var.alarm_topic_name
}

resource "aws_sns_topic_subscription" "email_subscription" {
  count     = length(var.alarm_email_endpoints)
  topic_arn = aws_sns_topic.alarms.arn
  protocol  = "email"
  endpoint  = var.alarm_email_endpoints[count.index]
}

# CloudWatch Log Groups
resource "aws_cloudwatch_log_group" "eb_app" {
  name              = "/aws/elasticbeanstalk/${var.app_name}/${var.environment_name}/var/log/app.log"
  retention_in_days = var.log_retention_days
  
  tags = merge(
    var.tags,
    {
      Application = var.app_name
      Environment = var.environment_name
    }
  )
}

resource "aws_cloudwatch_log_group" "eb_nginx" {
  name              = "/aws/elasticbeanstalk/${var.app_name}/${var.environment_name}/var/log/nginx/access.log"
  retention_in_days = var.log_retention_days
  
  tags = merge(
    var.tags,
    {
      Application = var.app_name
      Environment = var.environment_name
    }
  )
}

# CloudWatch Alarms for Elastic Beanstalk
resource "aws_cloudwatch_metric_alarm" "eb_cpu_high" {
  alarm_name          = "${var.app_name}-eb-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = var.eb_cpu_threshold
  alarm_description   = "This alarm monitors EC2 CPU utilization for Elastic Beanstalk"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  
  dimensions = {
    AutoScalingGroupName = var.eb_autoscaling_group_name
  }
}

resource "aws_cloudwatch_metric_alarm" "eb_latency_high" {
  alarm_name          = "${var.app_name}-eb-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "Latency"
  namespace           = "AWS/ELB"
  period              = 300
  statistic           = "Average"
  threshold           = var.eb_latency_threshold
  alarm_description   = "This alarm monitors ELB latency for Elastic Beanstalk"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  
  dimensions = {
    LoadBalancerName = var.eb_load_balancer_name
  }
}

# CloudWatch Alarms for RDS
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  alarm_name          = "${var.app_name}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_cpu_threshold
  alarm_description   = "This alarm monitors RDS CPU utilization"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_free_storage_low" {
  alarm_name          = "${var.app_name}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_free_storage_threshold
  alarm_description   = "This alarm monitors RDS free storage space"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

resource "aws_cloudwatch_metric_alarm" "rds_connections_high" {
  alarm_name          = "${var.app_name}-rds-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.rds_connections_threshold
  alarm_description   = "This alarm monitors RDS connection count"
  alarm_actions       = [aws_sns_topic.alarms.arn]
  
  dimensions = {
    DBInstanceIdentifier = var.rds_identifier
  }
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "${var.app_name}-dashboard"
  
  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/EC2", "CPUUtilization", "AutoScalingGroupName", var.eb_autoscaling_group_name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "EC2 CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ELB", "Latency", "LoadBalancerName", var.eb_load_balancer_name]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "ELB Latency"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.rds_identifier]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.rds_identifier]
          ]
          period = 300
          stat   = "Average"
          region = var.aws_region
          title  = "RDS Free Storage Space"
        }
      }
    ]
  })
}