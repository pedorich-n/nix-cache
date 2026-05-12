resource "cloudflare_ruleset" "r2_index_rewrite" {
  zone_id     = local.cf_zone_id
  name        = "R2 default index.html rewrite"
  description = "Rewrite root path to index.html for R2 bucket"
  kind        = "zone"
  phase       = "http_request_transform"

  rules = [{
    ref         = "r2_root_index_rewrite"
    description = "Rewrite R2 root path to /index.html"
    expression  = "(http.host eq \"${local.r2_bucket_public_domain}\" and http.request.uri.path eq \"/\")"
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
