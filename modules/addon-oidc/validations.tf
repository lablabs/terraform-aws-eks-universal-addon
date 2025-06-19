resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition = !local.oidc_role_create || !(
        var.oidc_policy_enabled && var.oidc_assume_role_enabled
      )
      error_message = "The `oidc_policy_enabled` and `oidc_assume_role_enabled` cannot both be true at the same time."
    }

    precondition {
      condition     = !local.oidc_role_create || !var.oidc_policy_enabled || var.oidc_policy != ""
      error_message = "The `oidc_policy` variable must be set when `oidc_policy_enabled` is set to `true`."
    }

    precondition {
      condition = !local.oidc_role_create || !var.oidc_assume_role_enabled || (
        var.oidc_assume_role_arns != null && length(var.oidc_assume_role_arns) > 0
      )
      error_message = "The `oidc_assume_role_arns` variable must be set to non-empty list when `oidc_assume_role_enabled` is set to `true`."
    }

    precondition {
      condition = !local.oidc_role_create || (
        var.oidc_role_name != "" ||
        var.oidc_role_name_prefix != ""
      )
      error_message = "At least one of `oidc_role_name` or `oidc_role_name_prefix` must be set."
    }
  }
}
