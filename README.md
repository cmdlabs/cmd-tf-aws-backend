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
| resource\_prefix | A prefix applied to all resources to allow multiple instances of this module to be deployed in the same master account | string | n/a | yes |
| bucket\_region | The region to create the S3 bucket in | string | n/a | yes |
| bucket\_sse\_algorithm | Encryption algorithm to use on the S3 bucket. Currently only AES256 is supported | string | `"AES256"` | no |
| workspace_prefixes | A list of prefixes that will have IAM Roles created to allow access to specific paths in the S3 state bucket. | list | n/a | yes |
| assume\_policy | A map that allows you to specify additional AWS principles that will be added to the backend roles assume role policy | map | `{}` | no

## Workspace Prefixes
This variable is used to control the IAM policy and roles that will be generated. It is primarily used to restrict access to specific accounts (`workspace_prefixes = ["prod"]` = `path: env:/prod*`) but should be flexible enough to allow an arbitrarily deep structure (`workspace_prefixes = ["prod-ap-southeast-2"]` = `path: env:/prod-ap-southeast2*`)

## Assume Role Policy
The assume_role_policy by default will be set to the current account ID. This is primarily so can you can use the roles while your 'identity' account is under construction. Once your identity account is available you should specify the required assume_role_policy and the default will be removed.

Due to terraform lookup() only supporting string returns this cant be a list and needs to be specified as a string with principles seperated by commas in the event multiple entries are required.

The key used needs to match what is specified in workspace_prefixes.

```
  assume_policy = {
   prod    = "arn:aws:iam::xxxxxxxxxxxx:root,arn:aws:iam::yyyyyyyyyyyy:root"
   nonprod = "arn:aws:iam::xxxxxxxxxxxx:root,arn:aws:iam::yyyyyyyyyyyy:root"
   sandpit = "arn:aws:iam::xxxxxxxxxxxx:root,arn:aws:iam::yyyyyyyyyyyy:root"
  }
```