# terraform-aws-backend
A terraform module that implements what is describe in the Terraform S3 Backend [documentation](https://www.terraform.io/docs/backends/types/s3.html)

S3 Encryption is enabled and Public Access policies used to ensure security.

This module is expected to be deployed to a 'master' AWS account so that you can start using remote state as soon as possible. As this module creates the remote state backend, its statefile needs to be commited to git as it cannot be stored remotely. No sensetive information should be present in this file. 

It is also expected that you check the statefile for this module into git to avoid the chicken and egg problem.

## Resources
|Name | Resource | Description |
|-----|----------|-------------|
| \<prefix>-terraform-backend | S3 Bucket | Used to store Terraform state files |
| terraform-lock | DynamoDB Table | Used for workspace locking |
| terraform-backend | IAM Role | Role created that has access to all terraform workspaces |
| terraform-backend-\<workspace> | IAM Role | Role created that only has access to the specified workspace |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| bucket\_prefix | A prefix applied to the S3 bucket created to ensure a unique name. | string | n/a | yes |
| bucket\_region | The region to create the S3 bucket in | string | n/a | yes |
| bucket\_sse\_algorithm | Encryption algorithm to use on the S3 bucket. Currently only AES256 is supported | string | `"AES256"` | no |
| workspaces | A list of terraform workspaces that IAM Roles/Policy will be created for | list | n/a | yes |
