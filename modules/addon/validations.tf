resource "terraform_data" "validations" {
  lifecycle {
    precondition {
      condition = !local.argo_application_source_helm_enabled || (
        var.helm_repo_url != ""
        && var.helm_chart_name != ""
        && var.helm_chart_version != ""
        && var.helm_release_name != ""
      )
      error_message = "The `helm_repo_url`, `helm_chart_name`, `helm_chart_version`, and `helm_release_name` variables must be set when argo_source_type is set to `helm`."
    }

    precondition {
      condition = (
        !local.argo_application_source_kustomize_enabled
        && !local.argo_application_source_directory_enabled
        ) || (
        var.argo_source_repo_url != ""
        && var.argo_source_path != ""
        && var.argo_source_target_revision != ""
        && var.argo_name != ""
      )
      error_message = "The `argo_source_repo_url`, `argo_source_path`, `argo_source_target_revision` and `argo_name` variables must be set when argo_source_type is set to `kustomize` or `directory`."
    }
  }
}
