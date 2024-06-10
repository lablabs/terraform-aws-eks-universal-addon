locals {
  irsa_role_create         = var.enabled == true && var.rbac_create == true && var.service_account_create == true && var.irsa_role_create == true
  irsa_role_name_prefix    = try(coalesce(var.irsa_role_name_prefix), "")
  irsa_role_name           = try(trim("${local.irsa_role_name_prefix}-${var.irsa_role_name}", "-"), "")
  irsa_policy_enabled      = var.irsa_policy_enabled == true && try(length(var.irsa_policy) > 0, false)
  irsa_assume_role_enabled = var.irsa_assume_role_enabled == true && try(length(var.irsa_assume_role_arns) > 0, false)
}

data "aws_iam_policy_document" "this_assume" {
  count = local.irsa_role_create && local.irsa_assume_role_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.irsa_assume_role_arns
  }
}

resource "aws_iam_policy" "this" {
  count = local.irsa_role_create && (local.irsa_policy_enabled || local.irsa_assume_role_enabled) ? 1 : 0

  name   = local.irsa_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path   = "/"
  policy = var.irsa_assume_role_enabled ? data.aws_iam_policy_document.this_assume[0].json : var.irsa_policy

  tags = var.irsa_tags
}

data "aws_iam_policy_document" "this_irsa" {
  count = local.irsa_role_create ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}",
      ]
    }
  }
}

resource "aws_iam_role" "this" {
  count              = local.irsa_role_create ? 1 : 0
  name               = local.irsa_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy = data.aws_iam_policy_document.this_irsa[0].json
  tags               = var.irsa_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = local.irsa_role_create && (local.irsa_policy_enabled || local.irsa_assume_role_enabled) ? 1 : 0
  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "this_additional" {
  for_each = local.irsa_role_create ? var.irsa_additional_policies : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}
