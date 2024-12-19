module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  namespace   = var.namespace
  stage       = var.stage
  environment = var.environment
  name        = var.name
  attributes  = var.attributes
  context     = var.context
  tags        = var.tags
}
