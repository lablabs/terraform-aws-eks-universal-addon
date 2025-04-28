variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

# TODO: Do I need this?
variable "rbac_create" {
  type        = bool
  default     = true
  description = "Whether to create and use RBAC resources."
}

# TODO: Do I need this?
variable "service_account_create" {
  type        = bool
  default     = true
  description = "Whether to create Service Account."
}

variable "service_account_name" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account name. Defaults to the addon name."
}

variable "service_account_namespace" {
  type        = string
  default     = ""
  description = "The Kubernetes Service Account namespace. Defaults to the addon namespace."
}

variable "pod_identity_role_create" {
  type        = bool
  default     = true
  description = "Whether to create pod identity role."
}

variable "pod_identity_role_name_prefix" {
  type        = string
  default     = ""
  description = "Pod identity role name prefix. Either `pod_identity_role_name_prefix` or `pod_identity_role_name` must be set."
}

variable "pod_identity_role_name" {
  type        = string
  default     = ""
  description = "Pod identity role name. The value is prefixed by `pod_identity_role_name_prefix`. Either `pod_identity_role_name` or `pod_identity_role_name_prefix` must be set."
}

variable "pod_identity_policy_enabled" {
  type        = bool
  default     = false
  description = "Whether to create IAM policy specified by `pod_identity_policy`. Mutually exclusive with `pod_identity_assume_role_enabled`."
}

variable "pod_identity_policy" {
  type        = string
  default     = ""
  description = "AWS IAM policy JSON document to be attached to the pod identity role. Applied only if `pod_identity_policy_enabled` is `true`."
}

variable "pod_identity_assume_role_enabled" {
  type        = bool
  default     = false
  description = "Whether pod identity is allowed to assume role defined by `pod_identity_assume_role_arn`. Mutually exclusive with `pod_identity_policy_enabled`."
}

variable "pod_identity_assume_role_arns" {
  type        = list(string)
  default     = []
  description = "List of ARNs assumable by the pod identity role. Applied only if `pod_identity_assume_role_enabled` is `true`."
}

variable "pod_identity_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the pod identity role."
}

variable "pod_identity_additional_policies" {
  type        = map(string)
  default     = {}
  description = "Map of the additional policies to be attached to pod identity role. Where key is arbitrary id and value is policy ARN."
}

variable "pod_identity_tags" {
  type        = map(string)
  default     = {}
  description = "Pod identity resources tags."
}
