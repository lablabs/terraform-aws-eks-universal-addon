locals {
  # TODO: Do I need var.rbac_create and var.service_account_create conditions?
  pod_identity_role_create         = var.enabled && var.rbac_create && var.service_account_create && var.pod_identity_role_create
  pod_identity_role_name           = trim("${var.pod_identity_role_name_prefix}-${var.pod_identity_role_name}", "-")
  pod_identity_policy_enabled      = var.pod_identity_policy_enabled && length(var.pod_identity_policy) > 0
  pod_identity_assume_role_enabled = var.pod_identity_assume_role_enabled && length(var.pod_identity_assume_role_arns) > 0
}

data "aws_iam_policy_document" "this_assume" {
  count = local.pod_identity_role_create && local.pod_identity_assume_role_enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole"
    ]
    resources = var.pod_identity_assume_role_arns
  }
}

resource "aws_iam_policy" "this" {
  count = local.pod_identity_role_create && (local.pod_identity_policy_enabled || local.pod_identity_assume_role_enabled) ? 1 : 0

  name   = local.pod_identity_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path   = "/"
  policy = var.pod_identity_assume_role_enabled ? data.aws_iam_policy_document.this_assume[0].json : var.pod_identity_policy

  tags = var.pod_identity_tags
}

data "aws_iam_policy_document" "this_pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
    ]

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "this" {
  count = local.pod_identity_role_create ? 1 : 0

  name                 = local.pod_identity_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = data.aws_iam_policy_document.this_pod_identity[0].json
  permissions_boundary = var.pod_identity_permissions_boundary

  tags = var.pod_identity_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.pod_identity_role_create && (local.pod_identity_policy_enabled || local.pod_identity_assume_role_enabled) ? 1 : 0

  role       = aws_iam_role.this[0].name
  policy_arn = aws_iam_policy.this[0].arn
}

resource "aws_iam_role_policy_attachment" "this_additional" {
  for_each = local.pod_identity_role_create ? var.pod_identity_additional_policies : {}

  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

resource "aws_eks_pod_identity_association" "this" {
  count = local.pod_identity_role_create ? 1 : 0

  cluster_name    = var.cluster_name
  namespace       = var.service_account_namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.this[0].arn
}
