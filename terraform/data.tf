# See https://developers.cloudflare.com/r2/api/tokens/#permission-groups
data "cloudflare_api_token_permission_groups_list" "r2_read" {
  scope = urlencode("com.cloudflare.edge.r2.bucket")
  name  = urlencode("Workers R2 Storage Bucket Item Read")
}

# See https://developers.cloudflare.com/r2/api/tokens/#permission-groups
data "cloudflare_api_token_permission_groups_list" "r2_write" {
  scope = urlencode("com.cloudflare.edge.r2.bucket")
  name  = urlencode("Workers R2 Storage Bucket Item Write")
}

data "onepassword_vault" "homelab" {
  name = "HomeLab"
}

data "onepassword_item" "nix_cache" {
  vault = data.onepassword_vault.homelab.uuid
  title = "Nix_Cache"
}
