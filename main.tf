data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  name                 = "${var.project_name}-${var.environment}"
  alert_email          = var.alert_email != null && trimspace(var.alert_email) != "" ? var.alert_email : null
  route53_zone_id      = var.route53_zone_id != null && trimspace(var.route53_zone_id) != "" ? var.route53_zone_id : null
  domain_name          = var.domain_name != null && trimspace(var.domain_name) != "" ? var.domain_name : null
  cloudwatch_log_group = var.cloudwatch_log_group != null && trimspace(var.cloudwatch_log_group) != "" ? var.cloudwatch_log_group : "/${var.project_name}/${var.environment}/application"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "vpc" {
  source = "./modules/vpc"

  name                  = local.name
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  app_subnet_cidrs      = var.app_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  nat_gateway_mode      = var.nat_gateway_mode
  tags                  = local.common_tags
}

module "security" {
  source = "./modules/security"

  name     = local.name
  vpc_id   = module.vpc.vpc_id
  app_port = var.app_port
  db_port  = var.db_port
  tags     = local.common_tags
}

module "storage" {
  source = "./modules/storage"

  name          = local.name
  account_id    = data.aws_caller_identity.current.account_id
  region        = data.aws_region.current.region
  kms_key_arn   = module.security.kms_key_arn
  force_destroy = var.force_destroy_buckets
  tags          = local.common_tags
}

module "rds" {
  source = "./modules/rds"

  name                         = local.name
  subnet_ids                   = module.vpc.database_subnet_ids
  security_group_id            = module.security.database_security_group_id
  kms_key_arn                  = module.security.kms_key_arn
  database_name                = var.database_name
  master_username              = var.database_master_username
  instance_class               = var.database_instance_class
  allocated_storage            = var.database_allocated_storage
  max_allocated_storage        = var.database_max_allocated_storage
  multi_az                     = var.database_multi_az
  backup_retention_period      = var.database_backup_retention_period
  deletion_protection          = var.database_deletion_protection
  skip_final_snapshot          = var.database_skip_final_snapshot
  performance_insights_enabled = var.database_performance_insights_enabled
  tags                         = local.common_tags
}

module "iam" {
  source = "./modules/iam"

  name                  = local.name
  app_bucket_arn        = module.storage.app_bucket_arn
  kms_key_arn           = module.security.kms_key_arn
  database_secret_arn   = module.rds.master_user_secret_arn
  account_id            = data.aws_caller_identity.current.account_id
  region                = data.aws_region.current.region
  application_log_group = local.cloudwatch_log_group
  tags                  = local.common_tags
}

module "alb" {
  source = "./modules/alb"

  name                = local.name
  vpc_id              = module.vpc.vpc_id
  public_subnet_ids   = module.vpc.public_subnet_ids
  security_group_id   = module.security.alb_security_group_id
  target_port         = var.app_port
  certificate_arn     = var.certificate_arn
  logs_bucket_name    = module.storage.alb_logs_bucket_name
  health_check_path   = var.health_check_path
  deletion_protection = var.alb_deletion_protection
  tags                = local.common_tags

  depends_on = [module.storage]
}

module "ec2" {
  source = "./modules/ec2"

  name                  = local.name
  instance_type         = var.instance_type
  instance_profile_name = module.iam.instance_profile_name
  security_group_id     = module.security.app_security_group_id
  kms_key_arn           = module.security.kms_key_arn
  app_port              = var.app_port
  aws_region            = data.aws_region.current.region
  app_bucket_name       = module.storage.app_bucket_name
  database_secret_arn   = module.rds.master_user_secret_arn
  database_endpoint     = module.rds.endpoint
  cloudwatch_log_group  = local.cloudwatch_log_group
  tags                  = local.common_tags
}

module "autoscaling" {
  source = "./modules/autoscaling"

  name                    = local.name
  launch_template_id      = module.ec2.launch_template_id
  launch_template_version = module.ec2.launch_template_latest_version
  subnet_ids              = module.vpc.app_subnet_ids
  target_group_arns       = [module.alb.target_group_arn]
  min_size                = var.asg_min_size
  desired_capacity        = var.asg_desired_capacity
  max_size                = var.asg_max_size
  cpu_target_value        = var.asg_cpu_target_value
  tags                    = local.common_tags
}

module "monitoring" {
  source = "./modules/monitoring"

  name                     = local.name
  autoscaling_group_name   = module.autoscaling.autoscaling_group_name
  load_balancer_arn_suffix = module.alb.arn_suffix
  database_identifier      = module.rds.identifier
  aws_region               = data.aws_region.current.region
  application_log_group    = local.cloudwatch_log_group
  kms_key_arn              = module.security.kms_key_arn
  vpc_id                   = module.vpc.vpc_id
  alert_email              = local.alert_email
  tags                     = local.common_tags
}

resource "aws_route53_record" "application" {
  count = local.route53_zone_id != null && local.domain_name != null ? 1 : 0

  zone_id = local.route53_zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = module.alb.dns_name
    zone_id                = module.alb.zone_id
    evaluate_target_health = true
  }
}
