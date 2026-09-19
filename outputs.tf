output "application_url" {
  description = "Application URL for the selected listener mode."
  value = var.enable_https ? (
    local.domain_name != null ? "https://${local.domain_name}" : null
  ) : "http://${module.alb.dns_name}"
}

output "alb_dns_name" { value = module.alb.dns_name }
output "vpc_id" { value = module.vpc.vpc_id }
output "app_subnet_ids" { value = module.vpc.app_subnet_ids }
output "database_endpoint" { value = module.rds.endpoint }
output "database_secret_arn" {
  value     = module.rds.master_user_secret_arn
  sensitive = true
}
output "app_bucket_name" { value = module.storage.app_bucket_name }
output "sns_topic_arn" { value = module.monitoring.sns_topic_arn }
output "target_group_arn" { value = module.alb.target_group_arn }
output "autoscaling_group_name" { value = module.autoscaling.autoscaling_group_name }
output "cloudwatch_dashboard_name" { value = module.monitoring.dashboard_name }
