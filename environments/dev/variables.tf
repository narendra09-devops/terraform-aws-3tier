variable "aws_region" {
  type    = string
  default = "eu-central-1"
}
variable "owner" {
  type    = string
  default = "Narendra-Singh"
}
variable "certificate_arn" {
  type     = string
  default  = null
  nullable = true
}
variable "alert_email" {
  type    = string
  default = null
}
variable "route53_zone_id" {
  type    = string
  default = null
}
variable "domain_name" {
  type    = string
  default = null
}
