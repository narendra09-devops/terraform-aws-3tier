variable "name" { type = string }
variable "vpc_cidr" { type = string }
variable "availability_zones" {
  type = list(string)
  validation {
    condition     = length(var.availability_zones) >= 2
    error_message = "At least two Availability Zones are required."
  }
}
variable "public_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.public_subnet_cidrs) >= 2
    error_message = "Provide at least two public subnet CIDRs."
  }
}
variable "app_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.app_subnet_cidrs) >= 2
    error_message = "Provide at least two application subnet CIDRs."
  }
}
variable "database_subnet_cidrs" {
  type = list(string)
  validation {
    condition     = length(var.database_subnet_cidrs) >= 2
    error_message = "Provide at least two database subnet CIDRs."
  }
}
variable "nat_gateway_mode" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
