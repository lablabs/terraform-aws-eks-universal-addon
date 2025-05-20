output "rbac_create" {
  description = "Whether RBAC resources are created and used"
  value       = var.rbac_create
}

output "service_account_create" {
  description = "Whether Service Account is created"
  value       = var.service_account_create
}

output "service_account_name" {
  description = "Service Account name"
  value       = var.service_account_name
}

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
  description = "IAM role attributes for IRSA"
  value       = try(aws_iam_role.irsa[0], {})
}

output "pod_identity_iam_role_attributes" {
  description = "IAM role attributes for pod identity"
  value       = try(aws_iam_role.pod_identity[0], {})
}
