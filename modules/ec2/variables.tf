variable "name" { type = string }
variable "ami_id" {
  type    = string
  default = null
}
variable "instance_type" { type = string }
variable "instance_profile_name" { type = string }
variable "security_group_id" { type = string }
variable "kms_key_arn" { type = string }
variable "app_port" { type = number }
variable "aws_region" { type = string }
variable "app_bucket_name" { type = string }
variable "database_secret_arn" {
  type      = string
  sensitive = true
}
variable "database_endpoint" { type = string }
variable "cloudwatch_log_group" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
