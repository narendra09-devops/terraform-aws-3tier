variable "name" { type = string }
variable "vpc_id" { type = string }
variable "app_port" { type = number }
variable "db_port" { type = number }
variable "enable_https" {
  type    = bool
  default = true
}
variable "tags" {
  type    = map(string)
  default = {}
}
