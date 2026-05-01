provider "cloudflare" {
  api_token = local.op_nix_cache_secrets["Cloudflare_API"]["token"]
}
