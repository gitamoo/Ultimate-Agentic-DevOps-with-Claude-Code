output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.site_distribution.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.site_distribution.domain_name
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket hosting the website"
  value       = aws_s3_bucket.site_bucket.id
}

output "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.site_bucket.arn
}
