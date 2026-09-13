variable "name" { type = string }
variable "autoscaling_group_name" { type = string }
variable "load_balancer_arn_suffix" { type = string }
variable "database_identifier" { type = string }
variable "aws_region" { type = string }
variable "application_log_group" { type = string }
variable "kms_key_arn" { type = string }
variable "log_retention_days" {
  type    = number
  default = 365
}
variable "alert_email" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "vpc_id" { type = string }
