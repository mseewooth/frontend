resource "aws_s3_bucket" "app" {
  bucket = local.s3_bucket_name

  tags = merge(local.tags, {
    Name = local.s3_bucket_name
  })
}

resource "aws_s3_bucket_versioning" "app_versioning" {
  bucket = aws_s3_bucket.app.id
  versioning_configuration {
    status = "Enabled"
  }
}

#resource "aws_s3_bucket_acl" "app_acl" {
#  bucket = aws_s3_bucket.app.id
#  acl    = "private"
#}

resource "aws_s3_bucket_ownership_controls" "app_ownership" {
    bucket = aws_s3_bucket.app.id
    rule  {
        object_ownership = "BucketOwnerEnforced"
    }
}

# Fixed resource name: aws_s3_bucket_public_access_block
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.app.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_cloudfront_origin_access_identity" "oai" {
    comment = "lab-frontend-app OAI for ${var.env}"
}

resource "aws_cloudfront_distribution" "cf_distribution" {
    origin {
        domain_name = aws_s3_bucket.app.bucket_regional_domain_name
        origin_id   = local.s3_origin_id

        s3_origin_config {
          origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path
        }
    }
    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
    compress               = true
  }

  ordered_cache_behavior {
    path_pattern     = "/index.html"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
    compress               = true
    viewer_protocol_policy = "redirect-to-https"
  }
    price_class = "PriceClass_100"
    viewer_certificate {
      cloudfront_default_certificate = true
    }
    retain_on_delete = false

    custom_error_response {
      error_caching_min_ttl = 300
      error_code = 403
      response_code = 200
      response_page_path = "/index.html"
    }
    restrictions {
      geo_restriction {
        restriction_type = "none"
      }
    }
}
data "aws_iam_policy_document" "app_s3_policy" {
    statement {
      actions = ["s3:GetObject"]
      resources = ["${aws_s3_bucket.app.arn}/*"]

      principals {
        type = "AWS"
        identifiers = [aws_cloudfront_origin_access_identity.oai.iam_arn]
      }
    }
}

resource "aws_s3_bucket_policy" "app_s3_policy" {
    bucket = aws_s3_bucket.app.id
    policy = data.aws_iam_policy_document.app_s3_policy.json 
}