output "oidc_role_enabled" {
  description = "Whether is oidc role enabled"
  value       = local.oidc_role_create
}

output "iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
}
