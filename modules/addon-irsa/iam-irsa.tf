locals {
  irsa_role_create = var.enabled && var.rbac_create && var.service_account_create && var.irsa_role_create
  irsa_role_name   = trim("${var.irsa_role_name_prefix}-${var.irsa_role_name}", "-")
  irsa_assume_role_policy_condition_values_default = length(var.service_account_namespace) > 0 && length(var.service_account_name) > 0 ? [
    format("system:serviceaccount:%s:%s", var.service_account_namespace, var.service_account_name)
  ] : [] # we want to use the default values only if the Service Account Namespace and name are defined
}

data "aws_iam_policy_document" "irsa_assume" {
  count = local.irsa_role_create && var.irsa_assume_role_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.irsa_assume_role_arns
  }
}

data "aws_iam_policy_document" "irsa_policy" {
  count = local.irsa_role_create && (var.irsa_policy_enabled || var.irsa_assume_role_enabled) ? 1 : 0

  source_policy_documents = compact([
    var.irsa_policy,
    one(data.aws_iam_policy_document.irsa_assume[*].json)
  ])
}

resource "aws_iam_policy" "irsa" {
  count = local.irsa_role_create && (var.irsa_policy_enabled || var.irsa_assume_role_enabled) ? 1 : 0

  description = "Policy for ${local.irsa_role_name} addon"
  name        = local.irsa_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path        = "/"
  policy      = data.aws_iam_policy_document.irsa_policy[0].json

  tags = var.irsa_tags
}

data "aws_iam_policy_document" "irsa" {
  count = local.irsa_role_create ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = var.irsa_assume_role_policy_condition_test
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"
      values   = coalescelist(var.irsa_assume_role_policy_condition_values, local.irsa_assume_role_policy_condition_values_default)
    }
  }

  dynamic "statement" {
    for_each = var.irsa_role_additional_trust_policies

    content {
      sid     = statement.key
      effect  = statement.value.effect
      actions = statement.value.actions

      dynamic "principals" {
        for_each = statement.value.principals

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }

      dynamic "condition" {
        for_each = statement.value.condition

        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

resource "aws_iam_role" "irsa" {
  count = local.irsa_role_create ? 1 : 0

  name                 = local.irsa_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = data.aws_iam_policy_document.irsa[0].json
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
