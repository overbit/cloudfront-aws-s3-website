data "aws_route53_zone" "private" {
  name         = "${var.environment}.abcam.net."
  private_zone = true
}

data "aws_route53_zone" "public" {
  name         = "${var.environment}.abcam.net."
  private_zone = false
}

resource "aws_route53_record" "private" {
  zone_id = data.aws_route53_zone.private.zone_id
  name    = aws_s3_bucket.lego_bucket.bucket
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.storybook_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.storybook_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "root-a" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = aws_s3_bucket.lego_bucket.bucket
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.storybook_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.storybook_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.default.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.public.zone_id
  name    = each.value.name
  records = [each.value.record]
  type    = each.value.type

  ttl             = "300"
  allow_overwrite = true
}
