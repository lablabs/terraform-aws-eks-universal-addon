# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.
module "addon-oidc" {
  for_each = local.addon_oidc

  source = "git::https://github.com/lablabs/terraform-aws-eks-universal-addon.git//modules/addon-oidc?ref=v0.0.22"

  enabled = var.enabled

  oidc_provider_create  = var.oidc_provider_create != null ? var.oidc_provider_create : lookup(local.addon, "oidc_provider_create", null)
  oidc_role_create      = var.oidc_role_create != null ? var.oidc_role_create : lookup(local.addon, "oidc_role_create", null)
  oidc_role_name_prefix = var.oidc_role_name_prefix != null ? var.oidc_role_name_prefix : lookup(local.addon, "oidc_role_name_prefix", "${local.addon.name}-oidc")
  oidc_role_name        = var.oidc_role_name != null ? var.oidc_role_name : lookup(local.addon, "oidc_role_name", local.addon_name)

  oidc_policy_enabled                        = var.oidc_policy_enabled != null ? var.oidc_policy_enabled : lookup(local.addon, "oidc_policy_enabled", null)
  oidc_policy                                = var.oidc_policy != null ? var.oidc_policy : lookup(local.addon, "oidc_policy", null)
  oidc_assume_role_enabled                   = var.oidc_assume_role_enabled != null ? var.oidc_assume_role_enabled : lookup(local.addon, "oidc_assume_role_enabled", null)
  oidc_assume_role_arns                      = var.oidc_assume_role_arns != null ? var.oidc_assume_role_arns : lookup(local.addon, "oidc_assume_role_arns", null)
  oidc_permissions_boundary                  = var.oidc_permissions_boundary != null ? var.oidc_permissions_boundary : lookup(local.addon, "oidc_permissions_boundary", null)
  oidc_additional_policies                   = var.oidc_additional_policies != null ? var.oidc_additional_policies : lookup(local.addon, "oidc_additional_policies", null)
  oidc_openid_client_ids                     = var.oidc_openid_client_ids != null ? var.oidc_openid_client_ids : lookup(local.addon, "oidc_openid_client_ids", null)
  oidc_openid_provider_url                   = var.oidc_openid_provider_url != null ? var.oidc_openid_provider_url : lookup(local.addon, "oidc_openid_provider_url", null)
  oidc_openid_thumbprints                    = var.oidc_openid_thumbprints != null ? var.oidc_openid_thumbprints : lookup(local.addon, "oidc_openid_thumbprints", null)
  oidc_assume_role_policy_condition_variable = var.oidc_assume_role_policy_condition_variable != null ? var.oidc_assume_role_policy_condition_variable : lookup(local.addon, "oidc_assume_role_policy_condition_variable", null)
  oidc_assume_role_policy_condition_values   = var.oidc_assume_role_policy_condition_values != null ? var.oidc_assume_role_policy_condition_values : lookup(local.addon, "oidc_assume_role_policy_condition_values", null)
  oidc_assume_role_policy_condition_test     = var.oidc_assume_role_policy_condition_test != null ? var.oidc_assume_role_policy_condition_test : lookup(local.addon, "oidc_assume_role_policy_condition_test", null)
  oidc_custom_provider_arn                   = var.oidc_custom_provider_arn != null ? var.oidc_custom_provider_arn : lookup(local.addon, "oidc_custom_provider_arn", null)

  oidc_tags = var.oidc_tags != null ? var.oidc_tags : lookup(local.addon, "oidc_tags", null)
}

output "addon_oidc" {
  description = "The OIDC addon module outputs"
  value       = module.addon-oidc
}
