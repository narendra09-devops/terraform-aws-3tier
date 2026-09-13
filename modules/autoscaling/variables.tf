variable "name" { type = string }
variable "launch_template_id" { type = string }
variable "launch_template_version" { type = number }
variable "subnet_ids" { type = list(string) }
variable "target_group_arns" { type = list(string) }
variable "min_size" { type = number }
variable "desired_capacity" { type = number }
variable "max_size" { type = number }
variable "cpu_target_value" { type = number }
variable "tags" {
  type    = map(string)
  default = {}
}
