variable "aws_region" {
  type    = string
  default = "eu-central-1"
}
variable "state_bucket_name" { type = string }
variable "github_repository" {
  description = "Repository in owner/name format."
  type        = string
}
variable "github_branches" {
  type    = list(string)
  default = ["main"]
}
variable "github_environments" {
  type    = list(string)
  default = ["dev"]
}
variable "deployment_policy_arns" {
  description = "Policies for the GitHub role. Default supports plan/read; supply a reviewed scoped deployment policy before enabling apply."
  type        = list(string)
  default     = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
variable "tags" {
  type = map(string)
  default = {
    ManagedBy = "Terraform"
    Purpose   = "three-tier-bootstrap"
  }
}
