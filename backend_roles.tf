#This role has full access to every environment
resource "aws_iam_role" "backend-all" {
  name               = "${var.resource_prefix}-terraform-backend"
  description        = "Allows access to all Terraform workspaces"
  assume_role_policy = data.aws_iam_policy_document.backend-assume-role-all.json
}

resource "aws_iam_role_policy" "backend-all" {
  name   = "${var.resource_prefix}-terraform-backend"
  policy = data.aws_iam_policy_document.iam-role-policy.json
  role   = "${var.resource_prefix}-terraform-backend"

  depends_on = [aws_iam_role.backend-all]
}

#These roles are limited to their specific workspace through the use of S3 resource permissions
resource "aws_iam_role" "backend-restricted" {
  count              = length(var.workspace_prefixes)
  name               = "${var.resource_prefix}-terraform-backend-${element(var.workspace_prefixes, count.index)}"
  description        = "Allows access to the ${element(var.workspace_prefixes, count.index)} workspace prefix "
  assume_role_policy = element(
    data.aws_iam_policy_document.backend-assume-role-restricted.*.json,
    count.index,
  )
}

resource "aws_iam_role_policy" "backend-restricted" {
  count  = length(var.workspace_prefixes)
  name   = "${var.resource_prefix}-terraform-backend-${element(var.workspace_prefixes, count.index)}"
  policy = element(
    data.aws_iam_policy_document.iam-role-policy-restricted.*.json,
    count.index,
  )
  role   = "${var.resource_prefix}-terraform-backend-${element(var.workspace_prefixes, count.index)}"

  depends_on = [aws_iam_role.backend-restricted]
}
