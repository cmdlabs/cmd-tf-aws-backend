resource "aws_s3_bucket" "backend" {
  bucket = "${var.bucket_prefix}-terraform-backend"
  region = "${var.bucket_region}"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "${var.bucket_sse_algorithm}"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = "${aws_s3_bucket.backend.id}"

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "lock" {
  name           = "terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

#Workaround for assume_role_policy not supporting aws_iam_policy resources
data "aws_iam_policy_document" "backend-assume-role-default" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = ["${data.aws_caller_identity.current.account_id}"]
    }
  }
}

#This role has full access to every environment
resource "aws_iam_role" "backend-all" {
  name               = "terraform-backend"
  assume_role_policy = "${data.aws_iam_policy_document.backend-assume-role-default.json}"
}

resource "aws_iam_role_policy" "backend-all" {
  name   = "terraform-backend"
  policy = "${data.template_file.iam-role-policy.rendered}"
  role   = "terraform-backend"

  depends_on = ["aws_iam_role.backend-all"]
}

#These roles are limited to their specific workspace through the use of S3 resource permissions
resource "aws_iam_role" "backend-restricted" {
  count              = "${length(var.workspaces)}"
  name               = "terraform-backend-${element(var.workspaces, count.index)}"
  assume_role_policy = "${data.aws_iam_policy_document.backend-assume-role-default.json}"
}

resource "aws_iam_role_policy" "backend-restricted" {
  count  = "${length(var.workspaces)}"
  name   = "terraform-backend-${element(var.workspaces, count.index)}"
  policy = "${element(data.template_file.iam-role-policy-restricted.*.rendered, count.index)}"
  role   = "terraform-backend-${element(var.workspaces, count.index)}"

  depends_on = ["aws_iam_role.backend-restricted"]
}
