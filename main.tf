/**
 * # AWS EKS Universal Addon Terraform module
 *
 * A Terraform module to deploy the universal addon on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml)
 */
# FIXME: update addon docs above
locals {
  # FIXME: add addon configuration here
  addon = {
    name = "universal-addon"

    helm_chart_name    = "raw"
    helm_chart_version = "0.1.0"
    helm_repo_url      = "https://lablabs.github.io"

    values = yamlencode({
      # FIXME: add default values here or remove `values` if not needed
    })
  }
}
