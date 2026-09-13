# Portfolio and interview pack

## Resume bullet

Designed and automated a secure, highly available three-tier AWS platform using modular Terraform: multi-AZ VPC networking, private Auto Scaling EC2, HTTPS ALB, encrypted Multi-AZ RDS, Secrets Manager, KMS, S3 logging, CloudWatch/SNS observability, remote state, and OIDC-based GitHub Actions with IaC security gates.

## STAR explanation

**Situation:** A company needed a reproducible application platform that reduced direct exposure and tolerated an Availability Zone or instance failure.

**Task:** Build environment-aware infrastructure with separated web, application, and database tiers, secure secrets, monitoring, and controlled delivery.

**Action:** I designed six subnets across two AZs; put only ALB/NAT in public subnets; kept EC2 and RDS private; implemented reusable Terraform modules, KMS encryption, RDS-managed Secrets Manager credentials, IMDSv2, Session Manager, ALB/S3 logging, CloudWatch alarms, and GitHub OIDC validation/deployment gates.

**Result:** The platform is reproducible across dev/staging/prod, supports health-based replacement and scaling, keeps workloads off the public internet, and provides auditable plans, logs, metrics, and approvals.

## Interview questions to rehearse

1. Why are application and database subnets separate?
2. Why does production use one NAT Gateway per AZ while dev uses one?
3. How does an ALB detect and remove unhealthy instances?
4. How are database credentials kept out of Terraform variables and Git?
5. Why is IMDSv2 required and SSH omitted?
6. What happens if an EC2 instance or one AZ fails?
7. How does GitHub authenticate without access keys?
8. How would you reduce NAT cost with VPC endpoints?
9. Which controls would you add for internet attacks?
10. How would you migrate this into a multi-account landing zone?

## Suggested repository screenshots

- Architecture poster
- Green GitHub Actions quality pipeline
- VPC resource map showing all six subnets
- ALB healthy target group and HTTPS listener
- Auto Scaling replacement or scaling activity
- RDS connectivity/encryption page with identifiers redacted
- CloudWatch dashboard and one confirmed SNS alert

