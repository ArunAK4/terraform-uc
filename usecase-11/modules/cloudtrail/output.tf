output "cloudtrail_arn" {
  value = aws_cloudtrail.trail.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.cloudtrail_bucket.id
}