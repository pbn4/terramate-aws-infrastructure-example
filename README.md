#### Quickstart

**Prerequisites**:
-  3 AWS accounts in the same AWS organization:
   - management account of the organization,
   - 2 new accounts for dev and prod environment of example "product",
- environment accounts must have `OrganizationAccountAccessRole` IAM role that can be assumed from the management account,
- AWS CLI access to management account configured via `AWS_PROFILE` or some other method

Run:
1. Modify `organization_management_account_id` key of globals in `stacks/config.tm.hcl` with your management account ID,
2. Modify `account_id` key of globals for each environment in `stacks/myproduct/config.tm.hcl` with your environment account IDs,
3. Generate terraform code `terramate generate`,
4. Set the CLI AWS credentials to the management account via e.g. env variable `AWS_PROFILE` or some other method, 
5. Create S3 bucket in management account to store shared state remotely:
   ```terraform
   cd stacks/management-account/terraform-state && terraform init && terraform apply -auto-approve
   ```
6. Go back to repository root,
7. Apply the rest of the infrastructure:
   ```terraform
   terramate run -- terraform init && terramate run -- terraform apply -auto-approve
   ```
8. Destroy the infrastructure when you are finished:
   ```terraform
   terramate run --reverse -- terraform destroy -auto-approve
   ```