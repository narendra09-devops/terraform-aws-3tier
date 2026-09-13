variable "project_name" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "three-tier"
}

variable "environment" {
  description = "Environment name such as dev, staging, or prod."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be dev, staging, or prod."
  }
}

variable "vpc_cidr" { type = string }
variable "availability_zones" { type = list(string) }
variable "public_subnet_cidrs" { type = list(string) }
variable "app_subnet_cidrs" { type = list(string) }
variable "database_subnet_cidrs" { type = list(string) }

variable "nat_gateway_mode" {
  description = "single is cheaper; per_az removes the NAT AZ dependency."
  type        = string
  default     = "single"
  validation {
    condition     = contains(["single", "per_az"], var.nat_gateway_mode)
    error_message = "nat_gateway_mode must be single or per_az."
  }
}

variable "app_port" {
  type    = number
  default = 80
}
variable "db_port" {
  type    = number
  default = 3306
}
variable "certificate_arn" {
  description = "ACM certificate ARN for the HTTPS listener."
  type        = string
  validation {
    condition     = can(regex("^arn:[^:]+:acm:[^:]+:[0-9]{12}:certificate/.+$", var.certificate_arn))
    error_message = "certificate_arn must be a valid regional ACM certificate ARN."
  }
}
variable "health_check_path" {
  type    = string
  default = "/health"
}
variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "asg_min_size" {
  type    = number
  default = 2
}
variable "asg_desired_capacity" {
  type    = number
  default = 2
}
variable "asg_max_size" {
  type    = number
  default = 4
}
variable "asg_cpu_target_value" {
  type    = number
  default = 60
}
variable "database_name" {
  type    = string
  default = "appdb"
}
variable "database_master_username" {
  type      = string
  default   = "dbadmin"
  sensitive = true
}
variable "database_instance_class" {
  type    = string
  default = "db.t4g.micro"
}
variable "database_allocated_storage" {
  type    = number
  default = 20
}
variable "database_max_allocated_storage" {
  type    = number
  default = 100
}
variable "database_multi_az" {
  type    = bool
  default = false
}
variable "database_backup_retention_period" {
  type    = number
  default = 7
}
variable "database_deletion_protection" {
  type    = bool
  default = false
}
variable "database_skip_final_snapshot" {
  type    = bool
  default = true
}
variable "database_performance_insights_enabled" {
  description = "Enable RDS Performance Insights on supported instance classes."
  type        = bool
  default     = false
}
variable "alb_deletion_protection" {
  type    = bool
  default = false
}
variable "force_destroy_buckets" {
  type    = bool
  default = false
}
variable "cloudwatch_log_group" {
  description = "Optional override; defaults to /<project>/<environment>/application."
  type        = string
  default     = null
}
variable "alert_email" {
  description = "Optional email endpoint for SNS alarm notifications."
  type        = string
  default     = null
}
variable "route53_zone_id" {
  description = "Optional existing public hosted zone ID."
  type        = string
  default     = null
}
variable "domain_name" {
  description = "Optional record name, for example app.example.com."
  type        = string
  default     = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
