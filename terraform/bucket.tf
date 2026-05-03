resource "cloudflare_r2_bucket" "bucket" {
  account_id = local.cf_account_id
  name       = "niks3-cache"
  location   = "apac"
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

resource "cloudflare_r2_custom_domain" "custom_domain" {
  enabled     = true
  account_id  = local.cf_account_id
  zone_id     = local.cf_zone_id
  bucket_name = cloudflare_r2_bucket.bucket.name
  domain      = "nix-cache.${data.cloudflare_zone.main.name}"
  min_tls     = "1.0"
}

resource "cloudflare_ruleset" "r2_index_rewrite" {
  zone_id     = local.cf_zone_id
  name        = "R2 default index.html rewrite"
  description = "Rewrite root path to index.html for R2 bucket"
  kind        = "zone"
  phase       = "http_request_transform"

  rules = [{
    ref         = "r2_root_index_rewrite"
    description = "Rewrite / to /index.html"
    expression  = "(http.host eq \"${cloudflare_r2_custom_domain.custom_domain.domain}\" and http.request.uri.path eq \"/\")"
    action      = "rewrite"
    action_parameters = {
      uri = {
        path = {
          value = "/index.html"
        }
      }
    }
  }]
}
