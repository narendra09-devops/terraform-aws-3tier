# Complete implementation roadmap

Use the dev environment first. Each phase ends with evidence you can put in the repository or discuss in an interview.

## Phase 0 - Account safety and tools (half day)

1. Use a dedicated AWS sandbox account or tightly controlled development account.
2. Enable MFA on the root user, create an account alias, configure budgets, and set a small cost alert.
3. Install Terraform, AWS CLI, TFLint, Checkov, Git, and GitHub CLI.
4. Configure AWS CLI authentication and confirm with `aws sts get-caller-identity`.
5. Fork/copy this repository and protect the `main` branch.

Evidence: screenshot of the budget (hide account data), tool-version output, initial Git commit.

## Phase 1 - State and CI identity (half day)

1. Edit `bootstrap/terraform.tfvars`.
2. Create the versioned, encrypted state bucket.
3. Create the GitHub OIDC provider and plan role.
4. Copy `backend.hcl.example` to `backend.hcl` for each environment and use a unique state key.
5. Add GitHub variables and environments; require a reviewer for `prod`.

Evidence: backend initialization, state-object versioning, OIDC trust-policy screenshot, successful quality job.

## Phase 2 - Network foundation (one day)

1. Deploy VPC, Internet Gateway, six subnets across two AZs, route tables, NAT Gateway(s), and tier security groups.
2. Verify that public subnets route to the Internet Gateway.
3. Verify that application subnets route outbound through NAT.
4. Verify that database subnets have no default internet route.
5. Confirm no security group exposes SSH and only ALB security group accepts public HTTP/HTTPS.

Evidence: VPC resource map, route-table screenshots, `terraform output vpc_id`, network explanation in the README.

## Phase 3 - Data and compute layers (one to two days)

1. Create the KMS key and encrypted S3 application bucket.
2. Create RDS subnet group and MySQL; use RDS-managed credentials in Secrets Manager.
3. Create the application IAM role and instance profile.
4. Create the IMDSv2-only launch template and Auto Scaling Group in private subnets.
5. Confirm instances appear in Systems Manager without public IPs or SSH keys.

Evidence: encrypted-resource screenshots, secret ARN with value hidden, SSM managed-node view, healthy ASG instances.

## Phase 4 - Traffic, scaling, and resilience (one day)

1. Request/validate an ACM certificate and configure a matching Route 53 record.
2. Deploy ALB, HTTPS listener, HTTP redirect, target group, and access logging.
3. Test `/health` and the application page.
4. Stop one instance and observe ASG replacement while the service remains available.
5. Generate CPU load in dev and observe target-tracking scale-out/scale-in.

Evidence: valid HTTPS screenshot, healthy targets, replacement activity, scaling activity timeline.

## Phase 5 - Operations and security validation (one day)

1. Confirm Nginx logs reach the encrypted CloudWatch log group.
2. Confirm ALB logs reach S3 and lifecycle rules are present.
3. Subscribe to SNS and test an alarm.
4. Review the dashboard for EC2 CPU, ALB 5XX, and RDS CPU.
5. Run `terraform fmt -check -recursive`, `tflint --recursive`, and Checkov; resolve or document findings.

Evidence: dashboard screenshot, test notification, clean CI run, security findings and rationale.

## Phase 6 - Portfolio polish (half day)

1. Replace placeholder values in documentation but never commit credentials, state, plans, or real secret values.
2. Add the architecture poster to README and your portfolio project page.
3. Record a two-to-three-minute demo: diagram, Terraform plan, AWS console resources, failure test, and dashboard.
4. Add a release tag such as `v1.0.0`.
5. Add the resume bullet from `PORTFOLIO.md` and link the repository.

Evidence: tagged release, demo link, final screenshots, concise project write-up.

## Definition of done

- CI quality job is green.
- Dev applies from a reviewed plan and serves valid HTTPS.
- EC2 has no public IP and no inbound SSH.
- ALB targets are healthy across two AZs.
- RDS is private, encrypted, backed up, and uses Secrets Manager.
- Logs, alarms, dashboard, and SNS are verified.
- A failure/recovery test is documented.
- `terraform destroy` is tested in dev and costs return to zero/expected baseline.

