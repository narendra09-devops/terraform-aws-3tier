variable "name" { type = string }
variable "account_id" { type = string }
variable "region" { type = string }
variable "kms_key_arn" { type = string }
variable "force_destroy" {
  type    = bool
  default = false
}
variable "tags" {
  type    = map(string)
  default = {}
}
