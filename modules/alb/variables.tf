variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "security_group_id" { type = string }
variable "target_port" { type = number }
variable "certificate_arn" { type = string }
variable "logs_bucket_name" { type = string }
variable "health_check_path" { type = string }
variable "deletion_protection" { type = bool }
variable "tags" {
  type    = map(string)
  default = {}
}
