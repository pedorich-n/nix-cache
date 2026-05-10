output "r2_endpoint" {
  description = "R2 endpoint URL"
  value       = "${local.cf_account_id}.r2.cloudflarestorage.com"
  sensitive   = true
}

output "r2_public_domain" {
  description = "Public domain for the R2 bucket"
  value       = local.r2_bucket_public_endpoint
}

output "r2_bucket_name" {
  description = "Name of the created R2 bucket"
  value       = local.r2_bucket_name
}

# See https://developers.cloudflare.com/r2/api/s3/api/#bucket-region
output "r2_bucket_region" {
  description = "Region of the created R2 bucket"
  value       = local.r2_bucket_region
}

output "r2_bucket_access_key_id" {
  description = "API token for R2 access. Used as the S3 Access Key ID"
  value       = local.r2_bucket_access_key_id
  sensitive   = true
}

# See https://developers.cloudflare.com/r2/api/tokens/#get-s3-api-credentials-from-an-api-token
output "r2_bucket_access_key_secret" {
  value       = local.r2_bucket_access_key_secret
  sensitive   = true
  description = "SHA256 hash of the R2 API token. Used as the S3 Secret Access Key"
}

output "nix_signing_key_base64" {
  description = "Base64-encoded Nix signing key for cache signing"
  value       = local.nix_signing_key_base64
  sensitive   = true
}

output "niks3_server_url" {
  description = "URL of the Niks3 server"
  value       = local.niks3_server_url
  sensitive   = false
}

output "niks3_api_token" {
  description = "API token for Niks3 access."
  value       = local.niks3_api_token
  sensitive   = true
}

output "niks3_oidc_json_base64" {
  description = "Base64-encoded OIDC configuration for Niks3 (base64-encoded for Fly secrets)"
  value       = local.niks3_oidc_json_base64
  sensitive   = false
}

output "niks3_postgres_connection_string" {
  description = "Connection string for the Postgres database on Fly"
  value       = local.fly_postgres_connection_string
  sensitive   = true
}

output "fly_app_name" {
  description = "Name of the Fly app"
  value       = local.fly_app_name
  sensitive   = false
}
