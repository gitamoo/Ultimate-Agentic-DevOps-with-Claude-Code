# S3 backend for Terraform state management
# IMPORTANT: First run terraform init without this backend block enabled.
# After the initial infrastructure is created and S3 bucket exists, uncomment the
# terraform block below and run: terraform init -migrate-state
#
# This ensures Terraform state is persisted in S3 with DynamoDB locking for team collaboration.
#
# Required setup:
# 1. Create S3 bucket: aws s3api create-bucket --bucket <your-state-bucket-name> --region <region> --create-bucket-configuration LocationConstraint=<region>
# 2. Enable versioning: aws s3api put-bucket-versioning --bucket <your-state-bucket-name> --versioning-configuration Status=Enabled
# 3. Block public access: aws s3api put-public-access-block --bucket <your-state-bucket-name> --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
# 4. Create DynamoDB table: aws dynamodb create-table --table-name <your-lock-table-name> --attribute-definitions AttributeName=LockID,AttributeType=S --key-schema AttributeName=LockID,KeyType=HASH --billing-mode PAY_PER_REQUEST

# terraform {
#   backend "s3" {
#     bucket           = "YOUR-STATE-BUCKET-NAME"
#     key              = "portfolio-site/terraform.tfstate"
#     region           = "ap-south-1"
#     encrypt          = true
#     dynamodb_table   = "YOUR-LOCK-TABLE-NAME"
#   }
# }
