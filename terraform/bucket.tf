resource "cloudflare_r2_bucket" "bucket" {
  account_id = local.cf_account_id
  name       = "niks3-cache"
  location   = "apac"
}

resource "cloudflare_r2_managed_domain" "managed_domain" {
  account_id  = local.cf_account_id
  bucket_name = cloudflare_r2_bucket.bucket.name
  enabled     = true
}

resource "cloudflare_r2_bucket_cors" "cors" {
  account_id  = local.cf_account_id
  bucket_name = cloudflare_r2_bucket.bucket.name

  rules = [{
    allowed = {
      methods = ["GET", "PUT", "POST", "DELETE", "HEAD"]
      origins = ["*"] // TODO: restrict this?
    }
    id              = "${cloudflare_r2_bucket.bucket.name}-default"
    max_age_seconds = 3600
  }]
}
