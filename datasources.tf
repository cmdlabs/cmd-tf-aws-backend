data "aws_caller_identity" "current" {}

data "template_file" "iam-role-policy-restricted" {
  count    = "${length(var.workspaces)}"
  template = "${file("${path.module}/templates/iam-role-policy-restricted.json.tpl")}"

  vars = {
    bucket    = "${aws_s3_bucket.backend.id}"
    workspace = "${element(var.workspaces, count.index)}"
  }
}

data "template_file" "iam-role-policy" {
  template = "${file("${path.module}/templates/iam-role-policy.json.tpl")}"

  vars = {
    bucket = "${aws_s3_bucket.backend.id}"
  }
}
