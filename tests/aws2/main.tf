variable "resource_suffix" {}

module "tests" {
  source = "../"

  resource_suffix = var.resource_suffix
}
