locals {
  irsa_role_create = var.enabled && var.rbac_create && var.service_account_create && var.irsa_role_create
  irsa_role_name   = trim("${var.irsa_role_name_prefix}-${var.irsa_role_name}", "-")
  irsa_assume_role_policy_condition_values_default = length(var.service_account_namespace) > 0 && length(var.service_account_name) > 0 ? [
    format("system:serviceaccount:%s:%s", var.service_account_namespace, var.service_account_name)
  ] : [] # we want to use the default values only if the Service Account Namespace and name are defined

  irsa_policy = {
    Version = "2012-10-17"
    Statement = concat(
      [
        for s in try(jsondecode(var.irsa_policy).Statement, []) : s if var.irsa_policy_enabled && var.irsa_policy != null
      ],
      var.irsa_assume_role_enabled ? [{
        Effect   = "Allow"
        Action   = "sts:AssumeRole"
        Resource = var.irsa_assume_role_arns
      }] : []
    )
  }

  irsa_trust_policy = {
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect = "Allow"
          Action = "sts:AssumeRoleWithWebIdentity"
          Principal = {
            Federated = var.cluster_identity_oidc_issuer_arn
          }
          Condition = {
            (var.irsa_assume_role_policy_condition_test) = {
              "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub" = try(coalescelist(var.irsa_assume_role_policy_condition_values, local.irsa_assume_role_policy_condition_values_default), [])
            }
          }
        }
      ],
      [
        for key, statement in var.irsa_role_additional_trust_policies : {
          Sid    = key
          Effect = statement.effect
          Action = statement.actions
          Principal = {
            for principal in statement.principals : principal.type => principal.identifiers
          }
          Condition = {
            for condition in statement.condition : condition.test => {
              (condition.variable) = condition.values
            }
          }
        }
    ])
  }
}

resource "aws_iam_policy" "irsa" {
  count = local.irsa_role_create && (var.irsa_policy_enabled || var.irsa_assume_role_enabled) ? 1 : 0

  description = "Policy for ${local.irsa_role_name} addon"
  name        = local.irsa_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path        = "/"
  policy      = jsonencode(local.irsa_policy)

  tags = var.irsa_tags
}

resource "aws_iam_role" "irsa" {
  count = local.irsa_role_create ? 1 : 0

  name                 = local.irsa_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = jsonencode(local.irsa_trust_policy)
  permissions_boundary = var.irsa_permissions_boundary

  tags = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "irsa" {
  count = local.irsa_role_create && (var.irsa_policy_enabled || var.irsa_assume_role_enabled) ? 1 : 0

  role       = aws_iam_role.irsa[0].name
  policy_arn = aws_iam_policy.irsa[0].arn
}

resource "aws_iam_role_policy_attachment" "irsa_additional" {
  for_each = local.irsa_role_create ? var.irsa_additional_policies : {}

  role       = aws_iam_role.irsa[0].name
  policy_arn = each.value
}
