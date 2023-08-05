generate_hcl "main.tf" {
  content {
    data "terraform_remote_state" "s3_flow_logs" {
      backend = "s3"
      config = {
        bucket = "${global.terraform_state.bucket_name}"
        key            = "${terramate.stack.path.relative}/../s3-flow-logs/terraform.tfstate"
        region = "${global.terraform_state.region}"
      }
    }
    
    module "this" {
      source  = "terraform-aws-modules/vpc/aws"
      version = "5.1.1"

      name = "${global.env_name}"
      cidr = "10.0.0.0/16"

      azs             = ["${global.region}a", "${global.region}b", "${global.region}c"]
      private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
      public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
      database_subnets  = ["10.0.201.0/24", "10.0.202.0/24", "10.0.203.0/24"]

      create_database_subnet_group = true

      enable_nat_gateway = true
      enable_vpn_gateway = false
      single_nat_gateway = true

      flow_log_destination_arn  = "${data.terraform_remote_state.s3_flow_logs.outputs.this.s3_bucket_arn}"
      flow_log_destination_type = "s3"
      flow_log_file_format      = "parquet" 
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