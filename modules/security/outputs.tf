output "alb_security_group_id" { value = aws_security_group.alb.id }
output "app_security_group_id" { value = aws_security_group.app.id }
output "database_security_group_id" { value = aws_security_group.database.id }
output "kms_key_arn" { value = aws_kms_key.this.arn }
output "kms_key_id" { value = aws_kms_key.this.key_id }

