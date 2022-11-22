resource "aws_cloudfront_origin_access_identity" "storybook_access_identy" {
  comment = aws_s3_bucket.lego_bucket.bucket_domain_name
}

resource "aws_cloudfront_distribution" "storybook_distribution" {
  origin {
    domain_name = aws_s3_bucket.lego_bucket.bucket_domain_name
    origin_id   = "S3-.${aws_s3_bucket.lego_bucket.bucket}"
    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.storybook_access_identy.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  aliases = [aws_s3_bucket.lego_bucket.bucket]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-.${aws_s3_bucket.lego_bucket.bucket}"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }

      headers = ["Origin"]
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 31536000
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate_validation.default.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2019"
  }

  tags = local.common_tags
}

resource "aws_ssm_parameter" "distribution" {
  name      = "/application/${var.app_name}/${var.environment}/cloudfront-distribution"
  type      = "String"
  value     = aws_cloudfront_distribution.storybook_distribution.id
  tags      = local.common_tags
  overwrite = true
}
