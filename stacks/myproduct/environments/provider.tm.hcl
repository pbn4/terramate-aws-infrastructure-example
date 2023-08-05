generate_hcl "provider.tf" {
  content {
    provider "aws" {
      region = "${global.region}"
      assume_role {
        role_arn = "arn:aws:iam::${global.account_id}:role/OrganizationAccountAccessRole"
      }
    }
  }
}