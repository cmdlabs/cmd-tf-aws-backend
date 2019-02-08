module "tf-backend" {
  source = "../"

  resource_prefix = "deantftest"
  bucket_region = "ap-southeast-2"

  bucket_sse_algorithm = "AES256"

  workspace_prefixes = ["prod", "nonprod", "sandpit"]

  assume_policy = {}
}
