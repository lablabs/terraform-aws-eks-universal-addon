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
  value       = try(coalesce(one(aws_iam_role.irsa[*]), one(aws_iam_role.pod_identity[*])), {})
}

output "irsa_iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.irsa[0], {})
}

output "pod_identity_iam_role_attributes" {
  description = "IAM role attributes"
  value       = try(aws_iam_role.pod_identity[0], {})
}
