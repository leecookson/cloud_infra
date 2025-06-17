## obviously this was deployed from a local backend at first, before migrating projects to use this infra
module "s3_backend" {
  source                      = "abhisheksr01/s3-backend/aws"
  version                     = "0.1.0"
  bucket_name                 = var.terraform_backend_bucket_name
  dynamodb_table_name         = var.terraform_backend_dynamo_table_name
  tags                        = var.default_tags
  s3_bucket_kms_master_key_id = data.aws_kms_alias.aws_kms_s3_default_key.id
}

data "aws_kms_alias" "aws_kms_s3_default_key" {
  name = "alias/aws/s3"
}