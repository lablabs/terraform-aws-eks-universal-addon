output "iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
}
