moved {
  from = aws_iam_policy.this[0]
  to   = aws_iam_policy.irsa[0]
}

moved {
  from = aws_iam_role.this[0]
  to   = aws_iam_role.irsa[0]
}

moved {
  from = aws_iam_role_policy_attachment.this[0]
  to   = aws_iam_role_policy_attachment.irsa[0]
}

moved {
  from = aws_iam_role_policy_attachment.this_additional
  to   = aws_iam_role_policy_attachment.irsa_additional
}
