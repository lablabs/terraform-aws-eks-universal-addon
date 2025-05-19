variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
  nullable    = false
}

variable "helm_enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent installation of the module via Helm release."
  nullable    = false
}

variable "helm_chart_name" {
  type        = string
  default     = ""
  description = "Helm chart name to be installed. Required if `argo_source_type` is set to `helm`."
  nullable    = false
}

variable "helm_chart_version" {
  type        = string
  default     = ""
  description = "Version of the Helm chart. Required if `argo_source_type` is set to `helm`."
  nullable    = false
}

variable "helm_release_name" {
  type        = string
  default     = ""
  description = "Helm release name. Required if `argo_source_type` is set to `helm`."
  nullable    = false
}

variable "helm_repo_url" {
  type        = string
  default     = ""
  description = "Helm repository. Required if `argo_source_type` is set to `helm`."
  nullable    = false
}

variable "helm_create_namespace" {
  type        = bool
  default     = true
  description = "Create the Namespace if it does not yet exist."
  nullable    = false
}

variable "namespace" {
  type        = string
  description = "The Kubernetes Namespace in which the Helm chart will be installed (required)."
  nullable    = false
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional Helm sets which will be passed to the Helm chart values or Kustomize or directory configuration which will be passed to ArgoCD Application source."
  nullable    = false
}

variable "values" {
  type        = string
  default     = ""
  description = "Additional YAML encoded values which will be passed to the Helm chart."
  nullable    = false
}

variable "argo_name" {
  type        = string
  default     = ""
  description = "Name of the ArgoCD Application. Required if `argo_source_type` is set to `kustomize` or `directory`.  If `argo_source_type` is set to `helm`, ArgoCD Application name will equal `helm_release_name`."
  nullable    = false
}

variable "argo_namespace" {
  type        = string
  default     = "argo"
  description = "Namespace to deploy ArgoCD Application to."
  nullable    = false
}

variable "argo_enabled" {
  type        = bool
  default     = false
  description = "If set to `true`, the module will be deployed as ArgoCD Application, otherwise it will be deployed as a Helm release."
  nullable    = false
}

variable "argo_helm_enabled" {
  type        = bool
  default     = false
  description = "If set to `true`, the ArgoCD Application manifest will be deployed using Kubernetes provider as a Helm release. Otherwise it'll be deployed as a Kubernetes manifest. See README for more info."
  nullable    = false
}

variable "argo_helm_wait_timeout" {
  type        = string
  default     = "10m"
  description = "Timeout for ArgoCD Application Helm release wait job."
  nullable    = false
}

variable "argo_helm_wait_node_selector" {
  type        = map(string)
  default     = {}
  description = "Node selector for ArgoCD Application Helm release wait job."
  nullable    = false
}

variable "argo_helm_wait_tolerations" {
  type        = list(any)
  default     = []
  description = "Tolerations for ArgoCD Application Helm release wait job."
  nullable    = false
}

variable "argo_helm_wait_backoff_limit" {
  type        = number
  default     = 6
  description = "Backoff limit for ArgoCD Application Helm release wait job."
  nullable    = false
}

variable "argo_helm_wait_kubectl_version" {
  type        = string
  default     = "1.33.0" # renovate: datasource=github-releases depName=kubernetes/kubernetes
  description = "Version of kubectl to use for ArgoCD Application wait job."
  nullable    = false
}

variable "argo_source_type" {
  type        = string
  default     = "helm"
  description = "Source type for ArgoCD Application. Can be either `helm`, `kustomize`, or `directory`."
  nullable    = false

  validation {
    condition     = contains(["helm", "kustomize", "directory"], var.argo_source_type)
    error_message = "Source type must be either `helm`, `kustomize`, or `directory`."
  }
}

variable "argo_source_repo_url" {
  type        = string
  default     = ""
  description = "ArgoCD Application source repo URL. Required if `argo_source_type` is set to `kustomize` or `directory`."
  nullable    = false
}

variable "argo_source_target_revision" {
  type        = string
  default     = ""
  description = "ArgoCD Application source target revision. Required if `argo_source_type` is set to `kustomize` or `directory`."
  nullable    = false
}

variable "argo_source_path" {
  type        = string
  default     = ""
  description = "ArgoCD Application source path. Required if `argo_source_type` is set to `kustomize` or `directory`."
  nullable    = false
}

variable "argo_destination_server" {
  type        = string
  default     = "https://kubernetes.default.svc"
  description = "Destination server for ArgoCD Application."
  nullable    = false
}

variable "argo_project" {
  type        = string
  default     = "default"
  description = "ArgoCD Application project."
  nullable    = false
}

variable "argo_info" {
  type        = list(any)
  default     = [{ name = "terraform", value = "true" }]
  description = "ArgoCD Application manifest info parameter."
  nullable    = false
}

variable "argo_sync_policy" {
  type        = any
  default     = {}
  description = "ArgoCD Application manifest syncPolicy parameter."
  nullable    = false
}

variable "argo_metadata" {
  type        = any
  default     = { finalizers = ["resources-finalizer.argocd.argoproj.io"] }
  description = "ArgoCD Application metadata configuration. Override or create additional metadata parameters."
  nullable    = false
}

variable "argo_apiversion" {
  type        = string
  default     = "argoproj.io/v1alpha1"
  description = "ArgoCD Application apiVersion."
  nullable    = false
}

variable "argo_spec" {
  type        = any
  default     = {}
  description = "ArgoCD Application spec configuration. Configuration is extended by deep merging with the default spec parameters."
  nullable    = false
}

variable "argo_spec_override" {
  type        = any
  default     = {}
  description = "ArgoCD Application spec configuration. Configuration is overriden by merging natively with the default spec parameters."
  nullable    = false
}

variable "argo_operation" {
  type        = any
  default     = {}
  description = "ArgoCD Application manifest operation parameter."
  nullable    = false
}

variable "argo_helm_values" {
  type        = string
  default     = ""
  description = "Value overrides to use when deploying ArgoCD Application object with Helm."
  nullable    = false
}

variable "argo_kubernetes_manifest_computed_fields" {
  type        = list(string)
  default     = ["metadata.labels", "metadata.annotations", "metadata.finalizers"]
  description = "List of paths of fields to be handled as \"computed\". The user-configured value for the field will be overridden by any different value returned by the API after apply."
  nullable    = false
}

variable "argo_kubernetes_manifest_field_manager_name" {
  type        = string
  default     = "Terraform"
  description = "The name of the field manager to use when applying the Kubernetes manifest resource."
  nullable    = false
}

variable "argo_kubernetes_manifest_field_manager_force_conflicts" {
  type        = bool
  default     = false
  description = "Forcibly override any field manager conflicts when applying the kubernetes manifest resource."
  nullable    = false
}

variable "argo_kubernetes_manifest_wait_fields" {
  type        = map(string)
  default     = {}
  description = "A map of fields and a corresponding regular expression with a pattern to wait for. The provider will wait until the field matches the regular expression. Use * for any value."
  nullable    = false
}

variable "helm_repo_key_file" {
  type        = string
  default     = ""
  description = "Helm repositories cert key file."
  nullable    = false
}

variable "helm_repo_cert_file" {
  type        = string
  default     = ""
  description = "Helm repositories cert file."
  nullable    = false
}

variable "helm_repo_ca_file" {
  type        = string
  default     = ""
  description = "Helm repositories CA cert file."
  nullable    = false
}

variable "helm_repo_username" {
  type        = string
  default     = ""
  description = "Username for HTTP basic authentication against the Helm repository."
  nullable    = false
}

variable "helm_repo_password" {
  type        = string
  default     = ""
  description = "Password for HTTP basic authentication against the Helm repository."
  nullable    = false
}

variable "helm_devel" {
  type        = bool
  default     = false
  description = "Use Helm chart development versions, too. Equivalent to version '>0.0.0-0'. If version is set, this is ignored."
  nullable    = false
}

variable "helm_package_verify" {
  type        = bool
  default     = false
  description = "Verify the package before installing it. Helm uses a provenance file to verify the integrity of the chart; this must be hosted alongside the chart."
  nullable    = false
}

variable "helm_keyring" {
  type        = string
  default     = "~/.gnupg/pubring.gpg"
  description = "Location of public keys used for verification. Used only if `helm_package_verify` is `true`."
  nullable    = false
}

variable "helm_timeout" {
  type        = number
  default     = 300
  description = "Time in seconds to wait for any individual Kubernetes operation (like Jobs for hooks)."
  nullable    = false
}

variable "helm_disable_webhooks" {
  type        = bool
  default     = false
  description = "Prevent Helm chart hooks from running."
  nullable    = false
}

variable "helm_reset_values" {
  type        = bool
  default     = false
  description = "When upgrading, reset the values to the ones built into the Helm chart."
  nullable    = false
}

variable "helm_reuse_values" {
  type        = bool
  default     = false
  description = "When upgrading, reuse the last Helm release's values and merge in any overrides. If `helm_reset_values` is specified, this is ignored."
  nullable    = false
}

variable "helm_force_update" {
  type        = bool
  default     = false
  description = "Force Helm resource update through delete/recreate if needed."
  nullable    = false
}

variable "helm_recreate_pods" {
  type        = bool
  default     = false
  description = "Perform pods restart during Helm upgrade/rollback."
  nullable    = false
}

variable "helm_cleanup_on_fail" {
  type        = bool
  default     = false
  description = "Allow deletion of new resources created in this Helm upgrade when upgrade fails."
  nullable    = false
}

variable "helm_release_max_history" {
  type        = number
  default     = 0
  description = "Maximum number of release versions stored per release."
  nullable    = false
}

variable "helm_atomic" {
  type        = bool
  default     = false
  description = "If set, installation process purges chart on fail. The wait flag will be set automatically if atomic is used."
  nullable    = false
}

variable "helm_wait" {
  type        = bool
  default     = false
  description = "Will wait until all Helm release resources are in a ready state before marking the release as successful. It will wait for as long as timeout."
  nullable    = false
}

variable "helm_wait_for_jobs" {
  type        = bool
  default     = false
  description = "If wait is enabled, will wait until all Helm Jobs have been completed before marking the release as successful. It will wait for as long as timeout."
  nullable    = false
}

variable "helm_skip_crds" {
  type        = bool
  default     = false
  description = "If set, no CRDs will be installed before Helm release."
  nullable    = false
}

variable "helm_render_subchart_notes" {
  type        = bool
  default     = true
  description = "If set, render Helm subchart notes along with the parent."
  nullable    = false
}

variable "helm_disable_openapi_validation" {
  type        = bool
  default     = false
  description = "If set, the installation process will not validate rendered Helm templates against the Kubernetes OpenAPI Schema."
  nullable    = false
}

variable "helm_dependency_update" {
  type        = bool
  default     = false
  description = "Runs Helm dependency update before installing the chart."
  nullable    = false
}

variable "helm_replace" {
  type        = bool
  default     = false
  description = "Re-use the given name of Helm release, only if that name is a deleted release which remains in the history. This is unsafe in production."
  nullable    = false
}

variable "helm_description" {
  type        = string
  default     = ""
  description = "Set Helm release description attribute (visible in the history)."
  nullable    = false
}

variable "helm_lint" {
  type        = bool
  default     = false
  description = "Run the Helm chart linter during the plan."
  nullable    = false
}

variable "helm_set_sensitive" {
  type        = map(any)
  default     = {}
  description = "Value block with custom sensitive values to be merged with the values yaml that won't be exposed in the plan's diff."
  nullable    = false
}

variable "helm_postrender" {
  type        = map(any)
  default     = {}
  description = "Value block with a path to a binary file to run after Helm renders the manifest which can alter the manifest contents."
  nullable    = false
}
