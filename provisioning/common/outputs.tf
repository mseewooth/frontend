output "cloudfront_url" {
  value = "https://${aws_cloudfront_distribution.cf_distribution.domain_name}"
}

output "s3_bucket_name" {
    value = aws_s3_bucket.app.id
}