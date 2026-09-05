module "frontend-lab-resources" {
    source = "../../common"
    env = "dev"
}

output "s3_bucket_name" {
    value = module.frontend-lab-resources.s3_bucket_name
    description = "Target S3 bucket for sync operations"

}

output "cloudfront_url" {
    value = module.frontend-lab-resources.cloudfront_url
    description = "Public Cloudfront Domain url"
}

###Fetch current AWS account 
data "aws_caller_identity" "current" {}

## Print identity verification details 
output "aws_account_id" {
    value = data.aws_caller_identity.current.account_id
    description = "Target AWS Account Id"
}

output "aws_caller_arn" {
    value   = data.aws_caller_identity.current.arn
    description = "Target IAM user"
}