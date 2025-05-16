resource "terraform_data" "validations" {
  lifecycle {
    # IRSA
    precondition {
      condition = !local.irsa_role_create || (
        var.cluster_identity_oidc_issuer != "" &&
        var.cluster_identity_oidc_issuer_arn != ""
      )
      error_message = "The `cluster_identity_oidc_issuer` and `cluster_identity_oidc_issuer_arn` variables must be set when `irsa_role_create` is set to `true`."
    }

    precondition {
      condition = !local.irsa_role_create || !(
        var.irsa_policy_enabled && var.irsa_assume_role_enabled
      )
      error_message = "The `irsa_policy_enabled` and `irsa_assume_role_enabled` cannot both be true at the same time."
    }

    precondition {
      condition     = !local.irsa_role_create || !var.irsa_policy_enabled || var.irsa_policy != ""
      error_message = "The `irsa_policy` variable must be set when `irsa_policy_enabled` is set to `true`."
    }

    precondition {
      condition = !local.irsa_role_create || !var.irsa_assume_role_enabled || (
        var.irsa_assume_role_arns != null && length(var.irsa_assume_role_arns) > 0
      )
      error_message = "The `irsa_assume_role_arns` variable must be set to non-empty list when `irsa_assume_role_enabled` is set to `true`."
    }

    precondition {
      condition = !local.irsa_role_create || (
        var.irsa_role_name != "" ||
        var.irsa_role_name_prefix != ""
      )
      error_message = "At least one of `irsa_role_name` or `irsa_role_name_prefix` must be set."
    }

    # Pod identity
    precondition {
      condition     = !local.pod_identity_role_create || var.cluster_name != ""
      error_message = "The `cluster_name` variable must be set when `pod_identity_role_create` is set to `true`."
    }

    precondition {
      condition     = !local.pod_identity_role_create || !var.pod_identity_policy_enabled || var.pod_identity_policy != ""
      error_message = "The `pod_identity_policy` variable must be set when `pod_identity_policy_enabled` is set to `true`."
    }

    precondition {
      condition = !local.pod_identity_role_create || (
        var.pod_identity_role_name != "" ||
        var.pod_identity_role_name_prefix != ""
      )
      error_message = "At least one of `pod_identity_role_name` or `pod_identity_role_name_prefix` must be set."
    }
  }
}
