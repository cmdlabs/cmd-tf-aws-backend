# all defaults
module "tf-backend1" {
  source = "../"

  resource_prefix = "backend-ci-test1"
  bucket_region   = "ap-southeast-2"

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

  resource_prefix = "backend-ci-test2"
  bucket_region   = "ap-southeast-2"

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

  resource_prefix = "backend-ci-test3"
  bucket_region   = "ap-southeast-2"

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

  resource_prefix = "backend-ci-test4"
  bucket_region   = "ap-southeast-2"

  enable_customer_kms_key = true

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
