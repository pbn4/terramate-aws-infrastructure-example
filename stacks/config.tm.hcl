globals {
  terraform_required_version = "~> 1.5"
  terraform_aws_provider_version = "~> 5.0"

  organization_management_account_id = "123456789000"
  
  terraform_state = {
    bucket_name = "${global.organization_management_account_id}-terraform-state"
    dynamodb_table = "${global.organization_management_account_id}-terraform-state-lock-table"
    region = "eu-central-1"
    replication_region = "eu-west-1"
  }
}