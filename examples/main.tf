module "tf-backend" {
  source = "../"

  bucket_prefix = "deantftest"
  bucket_region = "ap-southeast-2"

  bucket_sse_algorithm = "AES256"

  workspaces = ["prod", "nonprod", "sandpit"]
}
