generate_hcl "main.tf" {
  content {
    data "terraform_remote_state" "kms" {
      backend = "s3"
      config = {
        bucket = "${global.terraform_state.bucket_name}"
        key            = "${terramate.stack.path.relative}/../../kms/terraform.tfstate"
        region = "${global.terraform_state.region}"
      }
    }
    
    module "this" {
      source        = "terraform-aws-modules/s3-bucket/aws"
      version       = "3.14.0"
      bucket        = "${global.account_id}-${global.region}-${global.product_name}-${global.env_name}-vpc-flow-logs"
      force_destroy = true

      attach_policy                         = false
      attach_deny_insecure_transport_policy = true

      versioning = {
        enabled = true
      }

      lifecycle_rule = [
        {
          id                                     = "log"
          enabled                                = true
          abort_incomplete_multipart_upload_days = 7

          expiration = {
            days = 7
          }

          noncurrent_version_expiration = {
            days = 7
          }
        }
      ]

      server_side_encryption_configuration = {
        rule = {
          apply_server_side_encryption_by_default = {
            sse_algorithm = "aws:kms"
            kms_key_id = "${data.terraform_remote_state.kms.outputs.this.key_arn}"
          }
        }
      }

      object_lock_configuration = {
        object_lock_enabled = "Enabled"
        rule                = {
          default_retention = {
            mode = "GOVERNANCE"
            days = 1
          }
        }
      }

      block_public_acls       = true
      block_public_policy     = true
      ignore_public_acls      = true
      restrict_public_buckets = true
    }
  }
}

generate_hcl "outputs.tf" {
  content {
    output "this" {
      description = "This module output object"
      value = module.this
    }
  }
}