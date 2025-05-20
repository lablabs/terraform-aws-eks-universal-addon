variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
  nullable    = false
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  default     = ""
  description = "The OIDC Identity issuer for the cluster (required for IRSA)."
  nullable    = false
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  default     = ""
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a Service Account (required for IRSA)."
  nullable    = false
}

variable "rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources."
  nullable    = false
}

variable "service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account."
  nullable    = false
}

variable "service_account_name" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account name."
  nullable    = false
}

variable "service_account_namespace" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account namespace."
  nullable    = false
}

variable "irsa_role_create" {
  type        = bool
  default     = true
  description = "Whether to create IRSA role and annotate Service Account."
  nullable    = false
}

variable "irsa_role_name_prefix" {
  type        = string
  default     = ""
  description = "IRSA role name prefix. Either `irsa_role_name_prefix` or `irsa_role_name` must be set."
  nullable    = false
}

variable "irsa_role_name" {
  type        = string
  default     = ""
  description = "IRSA role name. The value is prefixed by `irsa_role_name_prefix`. Either `irsa_role_name` or `irsa_role_name_prefix` must be set."
  nullable    = false
}

variable "irsa_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `irsa_policy`. Mutually exclusive with `irsa_assume_role_enabled`."
  nullable    = false
}

variable "irsa_policy" {
  type        = string
  default     = ""
  description = "AWS IAM policy JSON document to be attached to the IRSA role. Applied only if `irsa_policy_enabled` is `true`."
  nullable    = false
}

variable "irsa_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether IRSA is allowed to assume role defined by `irsa_assume_role_arn`. Mutually exclusive with `irsa_policy_enabled`."
  nullable    = false
}

variable "irsa_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs assumable by the IRSA role. Applied only if `irsa_assume_role_enabled` is `true`."
  nullable    = false
}

variable "irsa_permissions_boundary" {
  type        = string
  default     = null # Must be set to null to avoid creating a invalid permissions boundary
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role."
}

variable "irsa_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to IRSA role. Where key is arbitrary id and value is policy ARN."
  nullable    = false
}

variable "irsa_tags" {
  type        = map(string)
  default     = {}
  description = "IRSA resources tags."
  nullable    = false
}

variable "irsa_assume_role_policy_condition_test" {
  type        = string
  default     = "StringEquals"
  description = "Specifies the condition test to use for the assume role trust policy."
  nullable    = false
}

variable "irsa_assume_role_policy_condition_values" {
  type        = list(string)
  default     = []
  description = "Specifies the values for the assume role trust policy condition. Each entry in this list must follow the required format `system:serviceaccount:$service_account_namespace:$service_account_name`. If this variable is left as the default, `local.irsa_assume_role_policy_condition_values_default` is used instead, which is a list containing a single value. Note that if this list is defined, the `service_account_name` and `service_account_namespace` variables are ignored."
  nullable    = false
}

variable "cluster_name" {
  type        = string
  default     = ""
  description = "The name of the cluster (required for pod identity)."
  nullable    = false
}

variable "pod_identity_role_create" {
  type        = bool
  default     = false
  description = "Whether to create pod identity role and annotate Service Account."
  nullable    = false
}

variable "pod_identity_role_name_prefix" {
  type        = string
  default     = ""
  description = "Pod identity role name prefix. Either `pod_identity_role_name_prefix` or `pod_identity_role_name` must be set."
  nullable    = false
}

variable "pod_identity_role_name" {
  type        = string
  default     = ""
  description = "Pod identity role name. The value is prefixed by `pod_identity_role_name_prefix`. Either `pod_identity_role_name` or `pod_identity_role_name_prefix` must be set."
  nullable    = false
}

variable "pod_identity_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `pod_identity_policy`."
  nullable    = false
}

variable "pod_identity_policy" {
  type        = string
  default     = ""
  description = "AWS IAM policy JSON document to be attached to the pod identity role. Applied only if `pod_identity_policy_enabled` is `true`."
  nullable    = false
}

variable "pod_identity_permissions_boundary" {
  type        = string
  default     = null # Must be set to null to avoid creating a invalid permissions boundary
  description = "ARN of the policy that is used to set the permissions boundary for the pod identity role."
}

variable "pod_identity_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to pod identity role. Where key is arbitrary id and value is policy ARN."
  nullable    = false
}

variable "pod_identity_tags" {
  type        = map(string)
  default     = {}
  description = "Pod identity resources tags."
  nullable    = false
}
