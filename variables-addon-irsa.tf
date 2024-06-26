# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.

# ================ IRSA variables (optional) ================

variable "cluster_identity_oidc_issuer" {
  type        = string
  default     = null
  description = "The OIDC Identity issuer for the cluster (required)."
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  default     = null
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a Service Account (required)."
}

variable "rbac_create" {
  type        = bool
  default     = null
  description = "Whether to create and use RBAC resources. Defaults to `true`."
}

variable "service_account_create" {
  type        = bool
  default     = null
  description = "Whether to create Service Account. Defaults to `true`."
}

variable "service_account_name" {
  type        = string
  default     = null
  description = "The Kubernetes Service Account name. Defaults to addon name."
}

variable "service_account_namespace" {
  type        = string
  default     = null
  description = "The Kubernetes Service Account namespace. Defaults to addon namespace."
}

variable "irsa_role_create" {
  type        = bool
  default     = null
  description = "Whether to create IRSA role and annotate Service Account. Defaults to `true`."
}

variable "irsa_role_name_prefix" {
  type        = string
  default     = null
  description = "IRSA role name prefix. Defaults to addon IRSA component name with `irsa` suffix."
}

variable "irsa_role_name" {
  type        = string
  default     = null
  description = "IRSA role name. The value is prefixed by `var.irsa_role_name_prefix`. Defaults to addon Helm chart name."
}

variable "irsa_assume_role_enabled" {
  type        = bool
  default     = null
  description = "Whether IRSA is allowed to assume role defined by `irsa_assume_role_arn`. Defaults to `false`."
}

variable "irsa_assume_role_arns" {
  type        = list(string)
  default     = null
  description = "List of ARNs assumable by the IRSA role. Applied only if `irsa_assume_role_enabled` is `true`. Defaults to `\"\"`."
}

variable "irsa_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the IRSA role. Defaults to `null`."
}

variable "irsa_additional_policies" {
  type        = map(string)
  default     = null
  description = "Map of the additional policies to be attached to IRSA role. Where key is arbitrary id and value is policy ARN. Defaults to `{}`."
}

variable "irsa_tags" {
  type        = map(string)
  default     = null
  description = "IRSA resources tags. Defaults to `{}`."
}
