terraform {
  required_version = ">=1.1.2"

  # backend "s3" {
  #   region         = "eu-west-2"
  #   bucket         = "lab-terraform-state-bucket"
  #   key            = "nonprod/frontend-app/dev/terraform.tfstate"
  #   encrypt        = "true"
  #   dynamodb_table = "terraform-state-lock-dynamo"
  # }
}