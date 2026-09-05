locals {
    s3_bucket_name = "lab-frontend-${var.env}"
    s3_origin_id   = "S3-origin-lab-frontent-app-${var.env}"

    tags = {
        env         = var.env,
        Application = "lab-frontend-app" 
    }
}