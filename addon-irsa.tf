# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.
module "addon-irsa" {
  for_each = local.addon_irsa

  source = "git::https://github.com/lablabs/terraform-aws-eks-universal-addon.git//modules/addon-irsa?ref=v0.0.14"

  enabled = var.enabled

  cluster_identity_oidc_issuer     = var.cluster_identity_oidc_issuer != null ? var.cluster_identity_oidc_issuer : lookup(local.addon, "cluster_identity_oidc_issuer", null)
  cluster_identity_oidc_issuer_arn = var.cluster_identity_oidc_issuer_arn != null ? var.cluster_identity_oidc_issuer_arn : lookup(local.addon, "cluster_identity_oidc_issuer_arn", null)

  rbac_create               = var.rbac_create != null ? var.rbac_create : lookup(local.addon, "rbac_create", true)
  service_account_create    = var.service_account_create != null ? var.service_account_create : lookup(local.addon, "service_account_create", true)
  service_account_name      = var.service_account_name != null ? var.service_account_name : lookup(local.addon, "service_account_name", "")
  service_account_namespace = var.service_account_namespace != null ? var.service_account_namespace : lookup(local.addon, "service_account_namespace", "")

  irsa_role_create      = var.irsa_role_create != null ? var.irsa_role_create : lookup(local.addon, "irsa_role_create", true)
  irsa_role_name_prefix = var.irsa_role_name_prefix != null ? var.irsa_role_name_prefix : lookup(local.addon, "irsa_role_name_prefix", "")
  irsa_role_name        = var.irsa_role_name != null ? var.irsa_role_name : lookup(local.addon, "irsa_role_name", "")

  irsa_policy_enabled       = var.irsa_policy_enabled != null ? var.irsa_policy_enabled : lookup(local.addon, "irsa_policy_enabled", false)
  irsa_policy               = var.irsa_policy != null ? var.irsa_policy : lookup(local.addon, "irsa_policy", "")
  irsa_assume_role_enabled  = var.irsa_assume_role_enabled != null ? var.irsa_assume_role_enabled : lookup(local.addon, "irsa_assume_role_enabled", false)
  irsa_assume_role_arns     = var.irsa_assume_role_arns != null ? var.irsa_assume_role_arns : lookup(local.addon, "irsa_assume_role_arns", [])
  irsa_permissions_boundary = var.irsa_permissions_boundary != null ? var.irsa_permissions_boundary : lookup(local.addon, "irsa_permissions_boundary", null)
  irsa_additional_policies  = var.irsa_additional_policies != null ? var.irsa_additional_policies : lookup(local.addon, "irsa_additional_policies", tomap({}))

  irsa_assume_role_policy_condition_test   = var.irsa_assume_role_policy_condition_test != null ? var.irsa_assume_role_policy_condition_test : lookup(local.addon, "irsa_assume_role_policy_condition_test", "StringEquals")
  irsa_assume_role_policy_condition_values = var.irsa_assume_role_policy_condition_values != null ? var.irsa_assume_role_policy_condition_values : lookup(local.addon, "irsa_assume_role_policy_condition_values", [])

  irsa_tags = var.irsa_tags != null ? var.irsa_tags : lookup(local.addon, "irsa_tags", tomap({}))
}

output "addon_irsa" {
  description = "The addon IRSA module outputs"
  value       = module.addon-irsa
}
