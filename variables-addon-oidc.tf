# IMPORTANT: This file is synced with the "terraform-aws-eks-universal-addon" module. Any changes to this file might be overwritten upon the next release of that module.

# ================ oidc variables (optional) ================

variable "oidc_provider_create" {
  type        = bool
  default     = null
  description = "Whether to create OIDC provider. Defaults to `true`. Set to false if you want to disable default OIDC provider when oidc_custom_provider_arn is set."
}

variable "oidc_role_create" {
  type        = bool
  default     = null
  description = "Whether to create OIDC role and annotate Service Account. Defaults to `true`."
}

variable "oidc_role_name_prefix" {
  type        = string
  default     = null
  description = "OIDC role name prefix. Defaults to addon OIDC component name with `oidc` suffix."
}

variable "oidc_role_name" {
  type        = string
  default     = null
  description = "OIDC role name. The value is prefixed by `var.oidc_role_name_prefix`. Defaults to addon Helm chart name."
}

variable "oidc_policy_enabled" {
  type        = bool
  default     = null
  description = "Whether to create IAM policy specified by `oidc_policy`. Mutually exclusive with `oidc_assume_role_enabled`. Defaults to `false`."
}

variable "oidc_policy" {
  type        = string
  default     = null
  description = "Policy to be attached to the OIDC role. Applied only if `oidc_policy_enabled` is `true`."
}

variable "oidc_assume_role_enabled" {
  type        = bool
  default     = null
  description = "Whether OIDC is allowed to assume role defined by `oidc_assume_role_arn`. Mutually exclusive with `oidc_policy_enabled`. Defaults to `false`."
}

variable "oidc_assume_role_arns" {
  type        = list(string)
  default     = null
  description = "List of ARNs assumable by the OIDC role. Applied only if `oidc_assume_role_enabled` is `true`. Defaults to `[]`."
}

variable "oidc_permissions_boundary" {
  type        = string
  default     = null
  description = "ARN of the policy that is used to set the permissions boundary for the OIDC role. Defaults to `\"\"`."
}

variable "oidc_additional_policies" {
  type        = map(string)
  default     = null
  description = "Map of the additional policies to be attached to OIDC role. Where key is arbitrary id and value is policy ARN. Defaults to `{}`."
}

variable "oidc_tags" {
  type        = map(string)
  default     = null
  description = "OIDC resources tags. Defaults to `{}`."
}

variable "oidc_assume_role_policy_condition_test" {
  type        = string
  default     = null
  description = "Specifies the condition test to use for the assume role trust policy. Defaults to `StringLike`."
}

variable "oidc_assume_role_policy_condition_values" {
  type        = list(string)
  default     = null
  description = "Specifies the values for the assume role trust policy condition. Defaults to `[]`."
}

variable "oidc_assume_role_policy_condition_variable" {
  type        = string
  default     = null
  description = "Specifies the variable to use for the assume role trust policy. Defaults to `\"\"`."
}

variable "oidc_openid_client_ids" {
  type        = list(string)
  default     = null
  description = "List of OpenID Connect client IDs that are allowed to assume the OIDC provider. Defaults to `[]`."
}

variable "oidc_openid_provider_url" {
  type        = string
  default     = null
  description = "OIDC provider URL. Defaults to `\"\"`."
}

variable "oidc_openid_thumbprints" {
  type        = list(string)
  default     = null
  description = "List of thumbprints of the OIDC provider's server certificate. Defaults to `[]`."
}

variable "oidc_custom_provider_arn" {
  type        = string
  default     = null
  description = "Specifies a custom OIDC provider ARN. If specified, overrides provider created by this module. If set, it is recommended to disable default OIDC provider creation by setting var.oidc_provider_create to false. Defaults to `\"\"`."
}
