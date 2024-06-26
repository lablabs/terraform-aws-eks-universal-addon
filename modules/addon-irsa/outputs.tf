output "irsa_role_enabled" {
  description = "Whether is IRSA role enabled"
  value       = local.irsa_role_create
}

output "iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
}
