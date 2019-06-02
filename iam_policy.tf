data "aws_iam_policy_document" "iam-role-policy-restricted" {
  count = length(var.workspace_prefixes)

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}"]
  }

  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.backend.id}/env:/${element(var.workspace_prefixes, count.index)}*"]
  }

  statement {
    actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"]
    resources = ["arn:aws:dynamodb:*:*:table/${var.resource_prefix}-terraform-lock"]
  }
}

data "aws_iam_policy_document" "iam-role-policy" {
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
    resources = ["arn:aws:dynamodb:*:*:table/terraform-lock"]
  }
}

data "aws_iam_policy_document" "backend-assume-role-all" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = split(
        ",",
        lookup(
          var.assume_policy,
          "all",
          data.aws_caller_identity.current.account_id,
        ),
      )
    }
  }
}

data "aws_iam_policy_document" "backend-assume-role-restricted" {
  count = length(var.workspace_prefixes)

  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = split(
        ",",
        lookup(
          var.assume_policy,
          element(var.workspace_prefixes, count.index),
          data.aws_caller_identity.current.account_id,
        ),
      )
    }
  }
}
