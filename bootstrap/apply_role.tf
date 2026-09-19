# This role can only be assumed by jobs using an approved GitHub environment.
data "aws_iam_policy_document" "github_apply_trust" {
  statement {
    sid     = "GitHubEnvironmentOIDC"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        for environment in var.github_environments :
        "repo:${local.github_oidc_repository}:environment:${environment}"
      ]
    }
  }
}

resource "aws_iam_role" "github_apply" {
  name               = "three-tier-github-apply"
  assume_role_policy = data.aws_iam_policy_document.github_apply_trust.json

  tags = merge(var.tags, {
    Purpose = "three-tier-protected-apply"
  })
}

# The apply role requires access to update Terraform state after deployment.
resource "aws_iam_role_policy" "github_apply_state" {
  name   = "three-tier-apply-state-access"
  role   = aws_iam_role.github_apply.id
  policy = data.aws_iam_policy_document.github_state.json
}

# Retain read access for Terraform refresh and provider data sources.
# Project-specific write permissions will be attached separately.
resource "aws_iam_role_policy_attachment" "github_apply_read" {
  for_each = toset(var.deployment_policy_arns)

  role       = aws_iam_role.github_apply.name
  policy_arn = each.value
}

output "github_actions_apply_role_arn" {
  value = aws_iam_role.github_apply.arn
}
