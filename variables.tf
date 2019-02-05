variable "resource_prefix" {
  type        = "string"
  description = "A prefix applied to all resources to allow multiple instances of this module to be deployed in the same master account"
}

variable "bucket_region" {
  type        = "string"
  description = "The region to create the S3 bucket in"
}

variable "bucket_sse_algorithm" {
  type        = "string"
  description = "Encryption algorithm to use on the S3 bucket. Currently only AES256 is supported"
  default     = "AES256"
}

variable "workspace_prefixes" {
  type        = "list"
  description = "A list of prefixes that will have IAM Roles created to allow access to specific paths in the S3 state bucket"
}

variable "assume_policy" {
  type        = "map"
  description = "A map that allows you to specify additional AWS principles that will be added to the backend roles assume role policy"
  
  default = {}
}
