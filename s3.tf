locals {
  bucket_name = local.domain_name
}

resource "aws_s3_bucket" "lego_bucket" {
  bucket = local.bucket_name
  acl    = "private"

  versioning {
    enabled = false
  }

  tags = local.common_tags
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.lego_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.storybook_access_identy.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "lego_bucket" {
  bucket = aws_s3_bucket.lego_bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}
