variable "github_oidc_repository" {
  description = "Repository identity used in the GitHub OIDC subject. Use owner@OWNER_ID/repository@REPOSITORY_ID for immutable subject claims; leave null for the legacy owner/repository format."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition = (
      var.github_oidc_repository == null ||
      can(regex("^[^/@]+@[0-9]+/[^/@]+@[0-9]+$", var.github_oidc_repository))
    )
    error_message = "github_oidc_repository must use owner@OWNER_ID/repository@REPOSITORY_ID format."
  }
}

locals {
  github_oidc_repository = coalesce(
    var.github_oidc_repository,
    var.github_repository
  )
}
