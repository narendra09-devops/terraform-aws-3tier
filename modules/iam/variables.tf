variable "name" { type = string }
variable "app_bucket_arn" { type = string }
variable "kms_key_arn" { type = string }
variable "database_secret_arn" {
  type      = string
  sensitive = true
}
variable "account_id" { type = string }
variable "region" { type = string }
variable "application_log_group" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
