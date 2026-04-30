output "r2_endpoint" {
  description = "R2 endpoint URL"
  value       = "${var.cloudflare_account_id}.r2.cloudflarestorage.com"
}

output "r2_public_domain" {
  description = "Public domain for the R2 bucket"
  value       = cloudflare_r2_managed_domain.managed_domain.domain
}

output "r2_bucket_name" {
  description = "Name of the created R2 bucket"
  value       = cloudflare_r2_bucket.bucket.name
}

# See https://developers.cloudflare.com/r2/api/s3/api/#bucket-region
output "r2_bucket_region" {
  description = "Region of the created R2 bucket"
  value       = "auto"
}

output "r2_bucket_access_key_id" {
  description = "API token for R2 access. Used as the S3 Access Key ID"
  value       = cloudflare_api_token.bucket_r2_read_write.id
  sensitive   = true
}

# See https://developers.cloudflare.com/r2/api/tokens/#get-s3-api-credentials-from-an-api-token
output "r2_bucket_access_key_secret" {
  value       = sha256(cloudflare_api_token.bucket_r2_read_write.value)
  sensitive   = true
  description = "SHA256 hash of the R2 API token. Used as the S3 Secret Access Key"
}
