mock_provider "aws" {}
mock_provider "helm" {}
mock_provider "kubernetes" {}

provider "helm" {
  alias = "real"

  kubernetes = {
    host     = "https://127.0.0.1:65535"
    token    = "test"
    insecure = true
  }
}

variables {
  irsa_role_create         = false
  oidc_role_create         = false
  oidc_provider_create     = false
  oidc_custom_provider_arn = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.example.com/id/test"
}

run "helm_provider_check" {
  command = plan

  providers = {
    helm = helm.real
  }

  module {
    source = "./modules/addon"
  }

  variables {
    enabled           = true
    helm_enabled      = true
    argo_enabled      = false
    argo_helm_enabled = false

    namespace          = "test"
    helm_chart_name    = "hello-world"
    helm_chart_version = "0.1.0"
    helm_release_name  = "test-helm-release"
    helm_repo_url      = "https://helm.github.io/examples"
    values             = yamlencode({})
  }

  assert {
    condition     = helm_release.this[0].description == null
    error_message = "When helm_description is not set, addon module should set helm_release description to null, not empty string."
  }
  assert {
    condition     = helm_release.this[0].keyring == null
    error_message = "When helm_package_verify is false, addon module should set helm_release keyring to null regardless of helm_keyring input."
  }
}
