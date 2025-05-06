output "irsa_role_enabled" {
  description = "Whether IRSA role is enabled"
  value       = local.irsa_role_create
}

output "pod_identity_role_enabled" {
  description = "Whether pod identity role is enabled"
  value       = local.pod_identity_role_create
}

output "iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.this[0], {})
}
