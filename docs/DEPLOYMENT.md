# Deployment runbook

## Local checks

From the repository root:

```bash
chmod +x scripts/*.sh
./scripts/validate.sh
```

## Bootstrap

```bash
cd bootstrap
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform fmt -check
terraform validate
terraform plan -out=bootstrap.tfplan
terraform apply bootstrap.tfplan
```

Do not migrate the bootstrap configuration itself into the bucket it creates during the first run. You may do that later as a separate reviewed change.

## Environment deployment

```bash
cd environments/dev
cp backend.hcl.example backend.hcl
cp terraform.tfvars.example terraform.tfvars
# Edit both files.
terraform init -backend-config=backend.hcl
terraform plan -var-file=terraform.tfvars -out=tfplan
terraform show tfplan
terraform apply tfplan
```

## Validation

```bash
terraform output
curl -fsS https://YOUR_DOMAIN/health
aws elbv2 describe-target-health --target-group-arn YOUR_TARGET_GROUP_ARN
aws rds describe-db-instances --db-instance-identifier three-tier-dev-mysql
aws logs describe-log-streams --log-group-name /three-tier/dev/application
```

## Safe cleanup

```bash
terraform plan -destroy -var-file=terraform.tfvars
terraform destroy -var-file=terraform.tfvars
```

An S3 bucket cannot be deleted while it contains objects when `force_destroy=false`. Production RDS and ALB deletion protection also intentionally block accidental deletion. Change safeguards only through review, retain required snapshots/logs, then destroy.

## Common failures

| Symptom | Likely cause | Fix |
| --- | --- | --- |
| ALB access log `AccessDenied` | Bucket policy path, account, or encryption mismatch | Keep prefix `alb`, account ID in ARN, and SSE-S3 on the log bucket |
| Targets unhealthy | Nginx/user data not finished or SG path incorrect | Check `/var/log/cloud-init-output.log`, target health reason, and ALB-to-app SG rule |
| HTTPS name warning | Domain does not match certificate | Use a Route 53 record whose name is covered by the ACM certificate |
| Instance absent from SSM | NAT/DNS/role problem | Check private route, VPC DNS, instance profile, and SSM agent |
| CloudWatch log error | KMS or IAM permission issue | Check KMS Logs service statement and EC2 logging permissions |
| Apply blocked in GitHub | OIDC role is plan-only | Attach an approved, scoped deployment policy and retain environment approval |
