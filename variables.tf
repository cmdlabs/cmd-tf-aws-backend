variable "resource_prefix" {
  type        = string
  description = "A prefix applied to all resources to allow multiple instances of this module to be deployed in the same master account"
}

variable "workspace_details" {
  type        = map(list(string))
  description = "A map of lists with the format of 'workspace': ['aws principle', ...]. These workspaces will have IAM Roles created to allow access to specific paths in the S3 state bucket along with additional AWS principles that will be added to the backend roles assume role policy"
}

variable "workspace_key_prefix" {
  type        = string
  description = "The prefix applied to the state path inside the bucket"
  default     = "env:"
}

variable "prevent_unencrypted_uploads" {
  type        = bool
  description = "Attach a bucket policy that requires all uploaded files to be explicitly encrypted. Must set the encrypted flag on the backend config."
  default     = false
}

variable "enable_customer_kms_key" {
  type        = bool
  description = "Create a customer CMK rather than AWS managed CMK"
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags applied to all resources"
  default     = {}
}

variable "all_workspaces_details" {
  type        = list(string)
  description = "A list of aws principles that will be allowed to assume the backend-all role"
  default     = []
}
