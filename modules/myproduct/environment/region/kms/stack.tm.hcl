generate_hcl "main.tf" {
  content {
    module "this" {
      source  = "terraform-aws-modules/kms/aws"
      version = "1.5.0"
      
      description             = "Key used to encrypt cloudwatch log groups"
      deletion_window_in_days = 7
      enable_key_rotation     = true
      is_enabled              = true
      key_usage               = "ENCRYPT_DECRYPT"
      multi_region            = false

      enable_default_policy = true

      key_statements = [
        {
          sid = "AWSServices"
          actions = [
            "kms:Encrypt*",
            "kms:Decrypt*",
            "kms:ReEncrypt*",
            "kms:GenerateDataKey*",
            "kms:Describe*"
          ]
          resources = ["*"]

          principals = [
            {
              type        = "Service"
              identifiers = ["logs.${global.region}.amazonaws.com"]
            }
          ]

          conditions = [
            {
              test     = "StringEquals"
              variable = "aws:SourceAccount"
              values = [global.account_id]
            },
            {
              test     = "ArnLike"
              variable = "kms:EncryptionContext:aws:logs:arn"
              values = [
                "arn:aws:logs:${global.region}:${global.account_id}:log-group:*",
              ]
            }
          ]
        }
      ]  
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