stack {
  name        = "terraform-state"
  description = "terraform-state"
  id          = "f6646898-4825-4217-9fba-192782a657f7"
}

generate_hcl "main.tf" {
  content {
    provider "aws" {
      region = global.terraform_state.region
    }

    provider "aws" {
      alias  = "replica"
      region = global.terraform_state.replication_region
    }

    module "remote_state" {
      source = "nozaq/remote-state-s3-backend/aws"
      version = "1.5.0"
      
      override_s3_bucket_name = true
      s3_bucket_name = "${global.terraform_state.bucket_name}"
      enable_replication = true
      // TODO: You don't want this set to true in your project
      s3_bucket_force_destroy = true

      dynamodb_table_name = "${global.terraform_state.dynamodb_table}"
      dynamodb_enable_server_side_encryption = true

      providers = {
        aws         = aws
        aws.replica = aws.replica
      }
    }
  }
}