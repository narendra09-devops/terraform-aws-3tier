# Security design and threat controls

| Risk | Control in this project |
| --- | --- |
| Direct instance exposure | EC2 is private, has no public IP, and has no SSH ingress |
| Plain HTTP | Port 80 redirects to HTTPS; TLS listener uses a modern policy |
| Lateral movement | ALB, application, and database each have separate security groups |
| Metadata credential theft | Launch template requires IMDSv2 and a one-hop response limit |
| Static AWS keys in CI | GitHub Actions assumes an AWS role with short-lived OIDC credentials |
| Database password in code/state | RDS creates and rotates/stores the master secret in Secrets Manager |
| Unencrypted data | KMS for EBS, RDS, app S3, secrets, and CloudWatch; SSE-S3 for ALB logs as required by AWS |
| Accidental deletion | Production ALB/RDS deletion protection, final snapshot, state-bucket `prevent_destroy` |
| Missing detection | ALB logs, application logs, dashboard, alarms, and SNS notifications |
| Uncontrolled changes | Terraform plans, static checks, protected branch, environment approval |

## Intentional boundaries

This is a strong portfolio baseline, not a complete enterprise landing zone. Add AWS WAF, CloudFront, GuardDuty, Config, Security Hub, VPC endpoints, centralized logs, cross-account roles, automated backup policy, secret rotation logic, and organization SCPs when the project scope grows.

The GitHub bootstrap role is deliberately read-only by default. A deploy role must use a reviewed, account-specific policy. Never commit `terraform.tfstate`, `tfplan`, `.tfvars`, backend details, credentials, or secret values.

