variable "resource_suffix" {}

# all defaults
module "tf-backend1" {
  source = "../"

  resource_prefix = "backend-ci-test1-${var.resource_suffix}"

  workspace_details = {
    "prod"    = []
    "nonprod" = []
    "sandpit" = []
  }

  tags = {
    Owner      = "Foo"
    Department = "Bar"
  }
}

# all default with unencrypted upload protection
module "tf-backend2" {
  source = "../"

  resource_prefix = "backend-ci-test2-${var.resource_suffix}"

  prevent_unencrypted_uploads = true

  workspace_details = {
    "prod"    = []
    "nonprod" = []
    "sandpit" = []
  }
}

# customer KMS key
module "tf-backend3" {
  source = "../"

  resource_prefix = "backend-ci-test3-${var.resource_suffix}"

  enable_customer_kms_key = true

  workspace_details = {
    "prod"    = []
    "nonprod" = []
    "sandpit" = []
  }

  tags = {
    Owner      = "Foo"
    Department = "Bar"
  }
}

# with arns on workspaces
module "tf-backend4" {
  source = "../"

  resource_prefix = "backend-ci-test4-${var.resource_suffix}"

  enable_customer_kms_key = true

  all_workspaces_details = ["arn:aws:iam::471871437096:role/gitlab_runner", "arn:aws:iam::471871437096:root"]

  workspace_details = {
    "prod"    = ["arn:aws:iam::471871437096:role/gitlab_runner", "arn:aws:iam::471871437096:root"]
    "nonprod" = ["arn:aws:iam::471871437096:role/gitlab_runner", "arn:aws:iam::471871437096:root"]
    "sandpit" = ["arn:aws:iam::471871437096:role/gitlab_runner", "arn:aws:iam::471871437096:root"]
  }

  tags = {
    Owner      = "Foo"
    Department = "Bar"
  }
}
