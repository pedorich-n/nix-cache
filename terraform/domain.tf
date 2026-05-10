resource "cloudflare_dns_record" "nixks3_server" {
  for_each = local.fly_dns_records

  zone_id = data.cloudflare_zone.main.id
  name    = each.value.name
  type    = each.value.type
  content = each.value.value
  ttl     = 1 # Automatic TTL
  proxied = each.value.proxied
}
