locals {
  addon = {
    enabled            = false
    name               = "universal-addon"
    namespace          = "universal-addon"
    helm_chart_name    = "raw"
    helm_chart_version = "0.1.0"
    helm_repo_url      = "https://lablabs.github.io"
    values = yamlencode({
      # add default values here
    })
  }
}
