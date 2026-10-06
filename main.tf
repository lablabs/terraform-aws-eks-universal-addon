/**
 * # AWS EKS Universal Addon Terraform module
 *
 * A Terraform module to deploy the universal addon on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-universal-addon/actions/workflows/pre-commit.yaml)
 *
 * ## Usage
 *
 * This addon can be used in two ways:
 *
 * 1. **Using the sub modules, i.e. `addon` directly**: This is the recommended way when creating an addon as a simple wrapper without any additional configuration. i.e. no IAM policy, no default Helm values configuration.
 * 2. **Using the module as a template**: This is the recommended way when an addon would add additional configuration, i.e. multiple IRSA roles.
 *
 * ### Direct usage
 *
 * Use `modules/addon` to deploy a Helm chart. Add `modules/addon-irsa` only when the workload calls AWS APIs and needs an IAM role. Use `modules/addon-irsa` alone when the chart is deployed outside of Terraform. Pin `?ref=` to a release.
 *
 * ```hcl
 * module "<addon>-irsa" {
 *   source = "github.com/lablabs/terraform-aws-eks-universal-addon//modules/addon-irsa?ref=v1.0.2"
 *
 *   cluster_identity_oidc_issuer     = module.eks_cluster.eks_cluster_identity_oidc_issuer
 *   cluster_identity_oidc_issuer_arn = module.eks_cluster.eks_cluster_identity_oidc_issuer_arn
 *
 *   service_account_name      = "<addon>" # must match the Service Account created by the chart
 *   service_account_namespace = "<addon>"
 *
 *   irsa_role_name = "<addon>"
 *   irsa_additional_policies = {
 *     s3 = aws_iam_policy.<addon>.arn
 *   }
 * }
 *
 * module "<addon>" {
 *   source = "github.com/lablabs/terraform-aws-eks-universal-addon//modules/addon?ref=v1.0.2"
 *
 *   namespace = "<addon>"
 *
 *   helm_repo_url      = "https://charts.example.com"
 *   helm_chart_name    = "<addon>"
 *   helm_chart_version = "1.0.0"
 *   helm_release_name  = "<addon>"
 *
 *   values = yamlencode({
 *     serviceAccount = {
 *       annotations = {
 *         "eks.amazonaws.com/role-arn" = module.<addon>-irsa.iam_role_attributes.arn
 *       }
 *     }
 *   })
 *
 *   argo_enabled      = true
 *   argo_helm_enabled = true
 *   argo_sync_policy = {
 *     automated   = { enabled = true }
 *     syncOptions = ["CreateNamespace=true", "ServerSideApply=true"]
 *   }
 * }
 * ```
 *
 * Watch out for:
 *
 * - `namespace` has no default, and `helm_release_name` and `helm_chart_name` default to `""`. Always set all three.
 * - `argo_enabled` and `argo_helm_enabled` default to `false`, which installs a plain `helm_release`. To deploy an ArgoCD Application, set both to `true` (see [Deployment methods](#deployment-methods)).
 * - `addon-irsa` does not create the Service Account. It creates the IAM role only when `rbac_create`, `service_account_create` and `irsa_role_create` are all `true` (the defaults). Annotate the chart's Service Account with `iam_role_attributes.arn`.
 * - For EKS Pod Identity, set `irsa_role_create = false`, `pod_identity_role_create = true` and `cluster_name`. The module then creates the Pod Identity association, so the Service Account needs no annotation.
 * - Put CRD or operator dependencies into `depends_on`.
 *
 * ### Template usage
 *
 * 1. Hit "Use this template" button on the top right corner of this page.
 * 2. Look for `# FIXME config` comments in the code and update the values according to your needs.
 * 3. Update .templatesyncignore file to exclude the files you don't want to sync with this template, i.e. add IRSA/OIDC files to the `.templatesyncignore` file when not using them.
 * 4. Remove `modules` folder as modules within should be used from this repository.
 * 5. Remove files that are already excluded in `.templatesyncignore` file and not needed for the addon, i.e. `renovate.json`, `.github/workflows/renovate.yaml`, `variables-addon-irsa.tf` (if IRSA is not used)`.
 * 6. Update examples in the `examples` folder according to your needs.
 * 7. Run pre-commit hooks to validate the code and refresh README file.
 *
 * ### Template sync
 *
 * There is a GitHub Action workflow running every night that will automatically sync code with this template using main branch of this repository. It will create a PR with the changes. You can also trigger it manually when needed.
 * To enable the workflow GitHub Actions secrets and GitHub Application must be allowed for the repository. Contact the repository owner to set it up.
 *
 * ## Development
 *
 * 1. When modifying modules in the `modules` folder, release them using semantic versioning, i.e. `v0.0.1`, `v0.1.0`, `v1.0.0`. Afterwards create another PR to update the version in the `addon*.tf` files.
 * 2. When adding variable into `variables.tf` in the `modules` folder add `nullable = false` to the variables when the default value is NOT `null`.
 */
# FIXME config: update addon docs above, remove template usage guide
locals {
  # FIXME config: add addon configuration here
  addon = {
    name = "universal-addon"

    helm_chart_name    = "raw"
    helm_chart_version = "0.1.0"
    helm_repo_url      = "https://lablabs.github.io"
  }

  # FIXME config: add addon IRSA configuration here or remove if not needed
  addon_irsa = {
    (local.addon.name) = {
      # FIXME config: add default IRSA overrides here or leave empty if not needed, but make sure to keep at least one key
    }
  }

  # FIXME config: add addon OIDC configuration here or remove if not needed
  addon_oidc = {
    (local.addon.name) = {
      # FIXME config: add default OIDC overrides here or leave empty if not needed, but make sure to keep at least one key
    }
  }

  addon_values = yamlencode({
    # FIXME config: add default values here or leave empty if not needed
  })

  addon_depends_on = [
    # FIXME config: add dependencies here, i.e. CRDs, or leave empty if not needed
  ]
}
