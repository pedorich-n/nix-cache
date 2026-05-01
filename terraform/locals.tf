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
  r2_bucket_region            = "auto" # See https://developers.cloudflare.com/r2/api/s3/api/#bucket-region

  fly_app_name   = nonsensitive(local.op_nix_cache_secrets["Fly"]["app_name"])
  fly_public_url = "https://${local.fly_app_name}.fly.dev"

  github_owner = "pedorich-n"
  github_repos = [
    "home-server-nixos"
  ]

  niks3_api_token = local.op_nix_cache_secrets["Niks3"]["api_token"]
  niks3_oidc = {
    providers : {
      github : {
        issuer : "https://token.actions.githubusercontent.com",
        audience : local.fly_app_name,
        bound_claims : {
          repository_owner : [
            local.github_owner
          ]
        },
        bound_subject : [for repo in local.github_repos : "repo:${local.github_owner}/${repo}:*"]
      }
    }
  }
  niks3_oidc_json        = jsonencode(local.niks3_oidc)
  niks3_oidc_json_base64 = base64encode(local.niks3_oidc_json)
}
