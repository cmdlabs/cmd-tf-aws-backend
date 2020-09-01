# terraform-aws-backend  
A terraform module that implements what is described in the Terraform S3 Backend [documentation](https://www.terraform.io/docs/backends/types/s3.html)

S3 Encryption is enabled by default and Public Access policies used to ensure security. Additionally, unencrypted uploads can be prevented, but this will require the `encrypt` key set on the backend configuration resource.

This module is expected to be deployed to a 'master' AWS account so that you can start using remote state as soon as possible. As this module creates the remote state backend, its statefile needs to be commited to git as it cannot be stored remotely. No sensetive information should be present in this file.

## Workspace Details  
This variable is used to control the IAM policy and roles that will be generated. It is primarily used to restrict access to specific accounts (`workspace_details = {"prod": []}` = `path: env:/prod*`) but should be flexible enough to allow an arbitrarily deep structure (`workspace_details = {"prod-ap-southeast-2": []}` = `path: env:/prod-ap-southeast2*`)

The policy by default will be set to the current account ID. This is primarily so can you can use the roles while your 'identity' account is under construction. Once your identity account is available you should specify the required principals and the default will be removed.

## Requirements

The following requirements are needed by this module:

- terraform ( >= 0.12.26)

- aws (>= 2.8.1)

## Required Inputs

The following input variables are required:

### resource\_prefix

Description: A prefix applied to all resources to allow multiple instances of this module to be deployed in the same master account

Type: `string`

### workspace\_details

Description: A map of lists with the format of 'workspace': ['aws principle', ...]. These workspaces will have IAM Roles created to allow access to specific paths in the S3 state bucket along with additional AWS principles that will be added to the backend roles assume role policy

Type: `map(list(string))`

## Optional Inputs

The following input variables are optional (have default values):

### all\_workspaces\_details

Description: A list of aws principles that will be allowed to assume the backend-all role

Type: `list(string)`

Default: `[]`

### enable\_customer\_kms\_key

Description: Create a customer CMK rather than AWS managed CMK

Type: `bool`

Default: `false`

### prevent\_unencrypted\_uploads

Description: Attach a bucket policy that requires all uploaded files to be explicitly encrypted. Must set the encrypted flag on the backend config.

Type: `bool`

Default: `false`

### tags

Description: Tags applied to all resources

Type: `map(string)`

Default: `{}`

### workspace\_key\_prefix

Description: The prefix applied to the state path inside the bucket

Type: `string`

Default: `"env:"`

## Outputs

The following outputs are exported:

### dynamo\_lock\_table

Description: n/a

### iam\_roles

Description: n/a

### state\_bucket\_id

Description: n/a

