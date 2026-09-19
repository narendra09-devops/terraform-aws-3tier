terraform {
  required_version = ">= 1.6.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0, < 7.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
  default_tags {
    tags = {
      Owner      = var.owner
      CostCenter = "portfolio"
    }
  }
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-name"
    values = ["${var.aws_region}a", "${var.aws_region}b"]
  }
}

module "platform" {
  source = "../.."

  project_name                          = "three-tier"
  environment                           = "prod"
  vpc_cidr                              = "10.30.0.0/16"
  availability_zones                    = slice(data.aws_availability_zones.available.names, 0, 2)
  public_subnet_cidrs                   = ["10.30.0.0/24", "10.30.1.0/24"]
  app_subnet_cidrs                      = ["10.30.10.0/24", "10.30.11.0/24"]
  database_subnet_cidrs                 = ["10.30.20.0/24", "10.30.21.0/24"]
  nat_gateway_mode                      = "per_az"
  certificate_arn                       = var.certificate_arn
  instance_type                         = "t3.small"
  asg_min_size                          = 2
  asg_desired_capacity                  = 2
  asg_max_size                          = 6
  database_instance_class               = "db.t4g.small"
  database_multi_az                     = true
  database_performance_insights_enabled = true
  database_backup_retention_period      = 14
  database_deletion_protection          = true
  database_skip_final_snapshot          = false
  alb_deletion_protection               = true
  alert_email                           = var.alert_email
  route53_zone_id                       = var.route53_zone_id
  domain_name                           = var.domain_name
}

output "application_url" { value = module.platform.application_url }
output "target_group_arn" { value = module.platform.target_group_arn }
output "autoscaling_group_name" { value = module.platform.autoscaling_group_name }
output "cloudwatch_dashboard_name" { value = module.platform.cloudwatch_dashboard_name }
