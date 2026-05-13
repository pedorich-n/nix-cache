resource "cloudflare_r2_custom_domain" "custom_domain" {
  enabled     = true
  account_id  = local.cf_account_id
  zone_id     = local.cf_zone_id
  bucket_name = cloudflare_r2_bucket.bucket.name
  domain      = "nix-cache.${data.cloudflare_zone.main.name}"
  min_tls     = "1.0"
}

resource "cloudflare_dns_record" "nixks3_server" {
  for_each = local.fly_dns_records

  zone_id = data.cloudflare_zone.main.id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 1 # Automatic TTL
  proxied = each.value.proxied
}
