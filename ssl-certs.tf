provider "aws" {
  alias  = "acm"
  region = "us-east-1" # certificate must be created in us-east-1 region
}

resource "aws_acm_certificate" "default" {
  provider    = aws.acm
  domain_name = local.domain_name
  #subject_alternative_names = ["*.${var.domain}"]
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
  tags = local.common_tags
}

resource "aws_acm_certificate_validation" "default" {
  provider                = aws.acm
  certificate_arn         = aws_acm_certificate.default.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
}
