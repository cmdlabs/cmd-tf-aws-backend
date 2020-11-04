resource "aws_kms_key" "backend" {
  count               = var.enable_customer_kms_key ? 1 : 0
  description         = "Customer key used to encrypt the backend S3 bucket"
  enable_key_rotation = var.enable_key_rotation
  policy              = data.aws_iam_policy_document.kms[0].json
  tags                = var.tags
}

resource "aws_kms_alias" "backend" {
  count         = var.enable_customer_kms_key ? 1 : 0
  name          = "alias/${var.resource_prefix}-terraform-backend"
  target_key_id = aws_kms_key.backend[0].id
}

data "aws_iam_policy_document" "kms" {
  count = var.enable_customer_kms_key ? 1 : 0
  statement {
    effect = "Allow"

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
      type = "AWS"
    }
    actions   = ["*"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"

    principals {
      identifiers = concat(aws_iam_role.backend_all[*].arn, values(aws_iam_role.backend_restricted)[*].arn)
      type        = "AWS"
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt",
      "kms:GenerateDataKey",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}
