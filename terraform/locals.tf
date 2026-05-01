locals {
  op_nix_cache_secrets = {
    for section in data.onepassword_item.nix_cache.section : section.label => {
      for field in section.field : field.label => field.value
    } if section.label != "" && section.label != "Related Items"
  }
  nix_signing_key_base64 = base64encode(local.op_nix_cache_secrets["Nix"]["signing_key"])
  cf_account_id          = local.op_nix_cache_secrets["Cloudflare_API"]["account_id"]

  r2_bucket_access_key_id     = cloudflare_api_token.bucket_r2_read_write.id
  r2_bucket_access_key_secret = sha256(cloudflare_api_token.bucket_r2_read_write.value)

}
