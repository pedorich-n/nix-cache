resource "cloudflare_r2_bucket" "bucket" {
  account_id = var.cloudflare_account_id
  name       = "niks3-cache"
  location   = "apac"
}

resource "cloudflare_r2_managed_domain" "managed_domain" {
  account_id  = var.cloudflare_account_id
  bucket_name = cloudflare_r2_bucket.bucket.name
  enabled     = false
}

resource "cloudflare_r2_bucket_cors" "cors" {
  account_id  = var.cloudflare_account_id
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


resource "cloudflare_api_token" "bucket_r2_read_write" {
  name   = "${cloudflare_r2_bucket.bucket.name}-RW"
  status = "active"

  policies = [{
    effect = "allow"
    permission_groups = [
      {
        id = data.cloudflare_api_token_permission_groups_list.r2_read.result[0].id
      },
      {
        id = data.cloudflare_api_token_permission_groups_list.r2_write.result[0].id
      },
    ]
    resources = jsonencode({
      # See https://developers.cloudflare.com/r2/api/tokens/#bucket
      # "com.cloudflare.edge.r2.bucket.<ACCOUNT_ID>_<JURISDICTION>_<BUCKET_NAME>"
      "com.cloudflare.edge.r2.bucket.${var.cloudflare_account_id}_default_${cloudflare_r2_bucket.bucket.name}" = "*"
    })
  }]
}
