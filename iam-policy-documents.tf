data "aws_iam_policy_document" "backend_assume_role_all" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = length(var.all_workspaces_details) > 0 ? var.all_workspaces_details : list(data.aws_caller_identity.current.account_id)
    }
  }
}

data "aws_iam_policy_document" "iam_role_policy_all" {
  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}/*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:*:*:table/${var.resource_prefix}-terraform-lock"]
  }
}

data "aws_iam_policy_document" "backend_assume_role_restricted" {
  for_each = var.workspace_details

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = "${length(each.value) > 0 ? each.value : list(data.aws_caller_identity.current.account_id)}"
    }
  }
}

data "aws_iam_policy_document" "iam_role_policy_restricted" {
  for_each = var.workspace_details

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}/env:/${each.key}*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:*:*:table/${var.resource_prefix}-terraform-lock"]
  }
}
