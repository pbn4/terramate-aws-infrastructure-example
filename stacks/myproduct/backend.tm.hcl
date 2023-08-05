generate_hcl "backend.tf" {
  content {
    terraform {
      backend "s3"  {
        bucket = "${global.terraform_state.bucket_name}"
        key            = "${terramate.stack.path.relative}/terraform.tfstate"
        region         = "${global.terraform_state.region}"
        encrypt        = true
        dynamodb_table = "${global.terraform_state.dynamodb_table}"
      }
    }
  }
}