locals {
  argo_application_enabled = var.enabled == true && var.argo_enabled == true && var.argo_helm_enabled == false ? 1 : 0

  argo_application_source_helm_enabled           = var.argo_source_type == "helm" ? true : false
  argo_application_source_kustomize_enabled      = var.argo_source_type == "kustomize" ? true : false
  argo_application_source_directory_enabled      = var.argo_source_type == "directory" ? true : false
  argo_application_source_helm_directory_enabled = var.argo_source_type == "helm-directory" ? true : false
  argo_application_source_helm_based             = local.argo_application_source_helm_enabled || local.argo_application_source_helm_directory_enabled

  argo_application_name = local.argo_application_source_helm_based ? var.helm_release_name : var.argo_name
  argo_application_source = {
    repoURL        = local.argo_application_source_helm_based ? var.helm_repo_url : var.argo_source_repo_url
    targetRevision = local.argo_application_source_helm_based ? var.helm_chart_version : var.argo_source_target_revision

    # Helm source
    chart = local.argo_application_source_helm_enabled ? var.helm_chart_name : null
    helm = local.argo_application_source_helm_based ? merge(
      {
        releaseName = var.helm_release_name
        skipCrds    = var.helm_skip_crds
        values      = var.values
      },
      length(var.settings) > 0 ? {
        parameters = [for k, v in var.settings : tomap({ forceString = true, name = k, value = v })]
      } : {}
    ) : null

    # Kustomize, Helm directory or directory source
    path      = !local.argo_application_source_helm_enabled ? var.argo_source_path : null
    kustomize = local.argo_application_source_kustomize_enabled ? length(var.settings) > 0 ? var.settings : null : null
    directory = local.argo_application_source_directory_enabled ? length(var.settings) > 0 ? var.settings : null : null
  }
  argo_application_source_normalized = {
    for k, v in local.argo_application_source : k => v if v != null # remove null values to avoid empty keys confusing ArgoCD source type
  }

  argo_application_metadata = {
    labels      = try(var.argo_metadata.labels, {}),
    annotations = try(var.argo_metadata.annotations, {}),
    finalizers  = try(var.argo_metadata.finalizers, [])
  }
  argo_application_spec = {
    project = var.argo_project
    source  = local.argo_application_source_normalized
    destination = {
      server    = var.argo_destination_server
      namespace = var.namespace
    }
    syncPolicy = var.argo_sync_policy
    info       = var.argo_info
  }
}

data "utils_deep_merge_yaml" "argo_application_spec" {
  count = local.argo_application_enabled

  input = compact([
    yamlencode(
      merge(
        local.argo_application_spec,
        var.argo_spec_override
      )
    ),
    yamlencode(var.argo_spec),
  ])
}

resource "kubernetes_manifest" "this" {
  count = local.argo_application_enabled

  manifest = merge(
    # the whole manifest cannot be deep merged (defers result to apply phase) due to kuberenetes_manifest CRD validation is happenning during the plan phase
    {
      apiVersion = var.argo_apiversion
      kind       = "Application"
      metadata = merge(
        local.argo_application_metadata,
        {
          name      = local.argo_application_name
          namespace = var.argo_namespace
        },
      )
      spec = yamldecode(data.utils_deep_merge_yaml.argo_application_spec[0].output)
    },
    length(var.argo_operation) > 0 ? {
      operation = var.argo_operation
    } : {}
  )

  computed_fields = var.argo_kubernetes_manifest_computed_fields

  field_manager {
    name            = var.argo_kubernetes_manifest_field_manager_name
    force_conflicts = var.argo_kubernetes_manifest_field_manager_force_conflicts
  }

  wait {
    fields = var.argo_kubernetes_manifest_wait_fields
  }
}
