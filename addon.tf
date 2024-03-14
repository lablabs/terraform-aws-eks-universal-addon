module "addon" {
  source = "git::https://github.com/lablabs/terraform-aws-eks-universal-addon.git?ref=main"

  enabled = local.addon.enabled

  namespace = coalesce(var.namespace, local.addon.namespace)

  helm_release_name               = coalesce(var.helm_release_name, local.addon.name)
  helm_chart_name                 = coalesce(var.helm_chart_name, try(local.addon.helm_chart_name, local.addon.name))
  helm_chart_version              = coalesce(var.helm_chart_version, local.addon.helm_chart_version)
  helm_atomic                     = var.helm_atomic
  helm_cleanup_on_fail            = var.helm_cleanup_on_fail
  helm_create_namespace           = var.helm_create_namespace
  helm_dependency_update          = var.helm_dependency_update
  helm_description                = var.helm_description
  helm_devel                      = var.helm_devel
  helm_disable_openapi_validation = var.helm_disable_openapi_validation
  helm_disable_webhooks           = var.helm_disable_webhooks
  helm_force_update               = var.helm_force_update
  helm_keyring                    = var.helm_keyring
  helm_lint                       = var.helm_lint
  helm_package_verify             = var.helm_package_verify
  helm_postrender                 = var.helm_postrender
  helm_recreate_pods              = var.helm_recreate_pods
  helm_release_max_history        = var.helm_release_max_history
  helm_render_subchart_notes      = var.helm_render_subchart_notes
  helm_replace                    = var.helm_replace
  helm_repo_ca_file               = var.helm_repo_ca_file
  helm_repo_cert_file             = var.helm_repo_cert_file
  helm_repo_key_file              = var.helm_repo_key_file
  helm_repo_password              = var.helm_repo_password
  helm_repo_url                   = coalesce(var.helm_repo_url, local.addon.helm_repo_url)
  helm_repo_username              = var.helm_repo_username
  helm_reset_values               = var.helm_reset_values
  helm_reuse_values               = var.helm_reuse_values
  helm_set_sensitive              = var.helm_set_sensitive
  helm_skip_crds                  = var.helm_skip_crds
  helm_timeout                    = var.helm_timeout
  helm_wait                       = var.helm_wait
  helm_wait_for_jobs              = var.helm_wait_for_jobs

  argo_apiversion                                        = var.argo_apiversion
  argo_destination_server                                = var.argo_destination_server
  argo_enabled                                           = var.argo_enabled
  argo_helm_enabled                                      = var.argo_helm_enabled
  argo_helm_values                                       = try(coalesce(var.argo_helm_values, local.addon.argo_helm_values), var.argo_helm_values)
  argo_helm_wait_backoff_limit                           = var.argo_helm_wait_backoff_limit
  argo_helm_wait_node_selector                           = try(coalesce(var.argo_helm_wait_node_selector, local.addon.argo_helm_wait_node_selector), var.argo_helm_wait_node_selector)
  argo_helm_wait_timeout                                 = var.argo_helm_wait_timeout
  argo_helm_wait_tolerations                             = try(coalesce(var.argo_helm_wait_tolerations, local.addon.argo_helm_wait_tolerations), var.argo_helm_wait_tolerations)
  argo_info                                              = var.argo_info
  argo_kubernetes_manifest_computed_fields               = var.argo_kubernetes_manifest_computed_fields
  argo_kubernetes_manifest_field_manager_force_conflicts = var.argo_kubernetes_manifest_field_manager_force_conflicts
  argo_kubernetes_manifest_field_manager_name            = var.argo_kubernetes_manifest_field_manager_name
  argo_kubernetes_manifest_wait_fields                   = try(coalesce(var.argo_kubernetes_manifest_wait_fields, local.addon.argo_kubernetes_manifest_wait_fields), var.argo_kubernetes_manifest_wait_fields)
  argo_metadata                                          = var.argo_metadata
  argo_namespace                                         = var.argo_namespace
  argo_project                                           = var.argo_project
  argo_spec                                              = try(coalesce(var.argo_spec, local.addon.argo_spec), var.argo_spec)
  argo_sync_policy                                       = try(coalesce(var.argo_sync_policy, local.addon.argo_sync_policy), var.argo_sync_policy)

  cluster_identity_oidc_issuer     = var.cluster_identity_oidc_issuer
  cluster_identity_oidc_issuer_arn = var.cluster_identity_oidc_issuer_arn
  irsa_role_create                 = var.irsa_role_create
  irsa_additional_policies         = var.irsa_additional_policies
  irsa_assume_role_arn             = var.irsa_assume_role_arn
  irsa_assume_role_enabled         = var.irsa_assume_role_enabled
  irsa_policy                      = var.irsa_policy
  irsa_policy_enabled              = var.irsa_policy_enabled
  irsa_role_name_prefix            = var.irsa_role_name_prefix
  irsa_tags                        = var.irsa_tags

  rbac_create            = var.rbac_create
  service_account_create = var.service_account_create
  service_account_name   = var.service_account_name

  settings = var.settings
  values   = one(data.utils_deep_merge_yaml.values[*].output)
}

data "utils_deep_merge_yaml" "values" {
  count = var.enabled ? 1 : 0
  input = compact([
    try(local.addon.values, ""),
    var.values
  ])
}
