locals {
  pod_identity_role_create = var.enabled && var.rbac_create && var.service_account_create && var.pod_identity_role_create
  pod_identity_role_name   = trim("${var.pod_identity_role_name_prefix}-${var.pod_identity_role_name}", "-")

  pod_identity_trust_policy = {
    Version = "2012-10-17"
    Statement = concat(
      [
        {
          Effect = "Allow"
          Action = [
            "sts:AssumeRole",
            "sts:TagSession",
          ]
          Principal = {
            Service = "pods.eks.amazonaws.com"
          }
        }
      ],
      [
        for key, statement in var.pod_identity_role_additional_trust_policies : {
          Sid    = key
          Effect = statement.effect
          Action = statement.actions
          Principal = {
            for principal in statement.principals : principal.type => principal.identifiers
          }
          Condition = {
            for condition in statement.condition : condition.test => {
              condition.variable = condition.values
            }
          }
        }
    ])
  }
}

resource "aws_iam_policy" "pod_identity" {
  count = local.pod_identity_role_create && var.pod_identity_policy_enabled ? 1 : 0

  description = "Policy for ${local.irsa_role_name} addon"
  name        = local.pod_identity_role_name # tflint-ignore: aws_iam_policy_invalid_name
  path        = "/"
  policy      = var.pod_identity_policy

  tags = var.pod_identity_tags
}

resource "aws_iam_role" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  name                 = local.pod_identity_role_name # tflint-ignore: aws_iam_role_invalid_name
  assume_role_policy   = jsonencode(local.pod_identity_trust_policy)
  permissions_boundary = var.pod_identity_permissions_boundary

  tags = var.pod_identity_tags
}

resource "aws_iam_role_policy_attachment" "pod_identity" {
  count = local.pod_identity_role_create && var.pod_identity_policy_enabled ? 1 : 0

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = aws_iam_policy.pod_identity[0].arn
}

resource "aws_iam_role_policy_attachment" "pod_identity_additional" {
  for_each = local.pod_identity_role_create ? var.pod_identity_additional_policies : {}

  role       = aws_iam_role.pod_identity[0].name
  policy_arn = each.value
}

resource "aws_eks_pod_identity_association" "pod_identity" {
  count = local.pod_identity_role_create ? 1 : 0

  cluster_name    = var.cluster_name
  namespace       = var.service_account_namespace
  service_account = var.service_account_name
  role_arn        = aws_iam_role.pod_identity[0].arn
  tags            = var.pod_identity_tags
}
