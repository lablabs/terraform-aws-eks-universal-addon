moved {
  from = aws_iam_policy.this
  to   = aws_iam_policy.irsa
}

moved {
  from = aws_iam_role.this
  to   = aws_iam_role.irsa
}

moved {
  from = aws_iam_role_policy_attachment.this
  to   = aws_iam_role_policy_attachment.irsa
}

moved {
  from = aws_iam_role_policy_attachment.this_additional
  to   = aws_iam_role_policy_attachment.irsa_additional
}
