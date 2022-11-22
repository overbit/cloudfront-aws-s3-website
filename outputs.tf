output "bucket_domain_name" {
  value = aws_s3_bucket.website_bucket.bucket_domain_name
}
output "bucket_endpoint" {
  value = aws_s3_bucket.website_bucket.bucket
}
output "bucket_arn" {
  value = aws_s3_bucket.website_bucket.arn
}
output "bucket_name" {
  value = aws_s3_bucket.website_bucket.bucket
}
