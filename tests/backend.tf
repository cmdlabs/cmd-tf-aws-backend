terraform {
  backend "s3" {
    bucket                  = "cmdlabtf-terraform-backend"
    key                     = "module-cmd-tf-aws-backend"
    region                  = "ap-southeast-2"
    profile                 = "cmdlabtf-tfbackend"
    dynamodb_table          = "cmdlabtf-terraform-lock"
    skip_metadata_api_check = true
  }
}
