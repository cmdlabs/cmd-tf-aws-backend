resource "aws_dynamodb_table" "lock" {
  name           = "${var.resource_prefix}-terraform-lock"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = var.enable_customer_kms_key ? aws_kms_key.backend[0].arn : null
  }

  tags = var.tags
}
