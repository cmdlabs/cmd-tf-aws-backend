/**
* # terraform-aws-backend
* A terraform module that implements what is described in the Terraform S3 Backend [documentation](https://www.terraform.io/docs/backends/types/s3.html)
*
* S3 Encryption is enabled by default and Public Access policies used to ensure security. Additionally, unencrypted uploads can be prevented, but this will require the `encrypt` key set on the backend configuration resource.
*
* This module is expected to be deployed to a 'master' AWS account so that you can start using remote state as soon as possible. As this module creates the remote state backend, its statefile needs to be commited to git as it cannot be stored remotely. No sensetive information should be present in this file.
*
* ## Workspace Details
* This variable is used to control the IAM policy and roles that will be generated. It is primarily used to restrict access to specific accounts (`workspace_details = {"prod": []}` = `path: env:/prod*`) but should be flexible enough to allow an arbitrarily deep structure (`workspace_details = {"prod-ap-southeast-2": []}` = `path: env:/prod-ap-southeast2*`)
*
* The policy by default will be set to the current account ID. This is primarily so can you can use the roles while your 'identity' account is under construction. Once your identity account is available you should specify the required principals and the default will be removed.
*
*/

resource "aws_s3_bucket" "backend" {
  bucket = "${var.resource_prefix}-terraform-backend"
  acl    = "private"
  policy = var.prevent_unencrypted_uploads ? data.aws_iam_policy_document.prevent_unencrypted_uploads.json : ""

  versioning {
    enabled    = true
    mfa_delete = var.mfa_delete
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "aws:kms"
        kms_master_key_id = var.enable_customer_kms_key ? aws_kms_key.backend[0].id : null
      }
    }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "prevent_unencrypted_uploads" {
  statement {
    sid    = "DenyIncorrectEncryptionHeader"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.resource_prefix}-terraform-backend/*"
    ]

    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "AES256",
        "aws:kms"
      ]
    }
  }

  statement {
    sid    = "DenyUnEncryptedObjectUploads"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:PutObject"
    ]
    resources = [
      "arn:aws:s3:::${var.resource_prefix}-terraform-backend/*"
    ]

    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values = [
        "true"
      ]
    }
  }

  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }
    actions = [
      "s3:*"
    ]
    resources = [
      "arn:aws:s3:::${var.resource_prefix}-terraform-backend/*"
    ]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}
