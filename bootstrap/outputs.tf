output "state_bucket_name" { value = aws_s3_bucket.state.id }
output "github_actions_role_arn" { value = aws_iam_role.github.arn }

