resource "aws_cloudwatch_log_metric_filter" "login_filter" {
  name           = "console-login-filter"
  log_group_name = var.log_group_name
  pattern        = "{ $.eventName = \"ConsoleLogin\" }"

  metric_transformation {
    name      = "ConsoleLoginCount"
    namespace = "CloudTrailMetrics"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "login_alarm" {
  alarm_name          = "ConsoleLoginAlarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "ConsoleLoginCount"
  namespace           = "CloudTrailMetrics"
  period              = 60
  statistic           = "Sum"
  threshold           = 1
  alarm_actions       = [var.sns_topic_arn]
}
resource "aws_cloudwatch_log_group" "cloudtrail_log_group" {
  name              = "/aws/cloudtrail/narendiran-cloudtrail"
  retention_in_days = 30 
}

resource "aws_cloudwatch_log_metric_filter" "login_filter" {
  name           = "narendiran-login"
  log_group_name = aws_cloudwatch_log_group.cloudtrail_log_group.name
  pattern        = "{ $.eventName = \"ConsoleLogin\" && $.responseElements.ConsoleLogin = \"Success\" }"

  metric_transformation {
    name      = var.metric_name
    namespace = var.metric_namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "login_alarm" {
  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  metric_name         = var.metric_name
  namespace           = var.metric_namespace
  statistic           = var.statistic
  period              = var.period
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  comparison_operator = var.comparison_operator
  alarm_actions       = [var.sns_topic_arn]

  treat_missing_data = "notBreaching"

  tags = var.project_tag
}