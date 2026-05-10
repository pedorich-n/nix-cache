locals {
  container_info          = jsondecode(file("${path.module}/templates/container.json"))
  container_image_url     = "${local.container_info.registry}/${local.container_info.image}@${local.container_info.digest}"
  container_image_version = local.container_info.version

  op_nix_cache_secrets = {
    for section in data.onepassword_item.nix_cache.section : section.label => {
      for field in section.field : field.label => field.value
    } if section.label != "" && section.label != "Related Items"
  }
  nix_signing_key_base64 = base64encode(local.op_nix_cache_secrets["Nix"]["signing_key"])

  cf_account_id = local.op_nix_cache_secrets["Cloudflare"]["account_id"]
  cf_zone_id    = local.op_nix_cache_secrets["Cloudflare"]["zone_id"]

  r2_bucket_access_key_id     = cloudflare_api_token.bucket_r2_read_write.id
  r2_bucket_access_key_secret = sha256(cloudflare_api_token.bucket_r2_read_write.value)
  r2_bucket_region            = "auto" # See https://developers.cloudflare.com/r2/api/s3/api/#bucket-region
  r2_bucket_name              = cloudflare_r2_bucket.bucket.name
  r2_bucket_public_endpoint   = cloudflare_r2_custom_domain.custom_domain.domain

  fly_app_name                   = nonsensitive(local.op_nix_cache_secrets["Fly"]["app_name"])
  fly_postgres_connection_string = local.op_nix_cache_secrets["Fly"]["postgres_url"]
  fly_dns_records = {
    "ipv4" : {
      type    = "A"
      name    = local.niks3_server_domain
      value   = local.op_nix_cache_secrets["Fly_domain_DNS"]["a"]
      proxied = true
    },
    "ipv6" : {
      type    = "AAAA"
      name    = local.niks3_server_domain
      value   = local.op_nix_cache_secrets["Fly_domain_DNS"]["aaaa"]
      proxied = true
    },
    "ownership" : {
      type    = "TXT"
      name    = "_fly-ownership.${local.niks3_server_domain}"
      value   = "\"${local.op_nix_cache_secrets["Fly_domain_DNS"]["ownership"]}\""
      proxied = false
    },
    "acme_challenge" : {
      type    = "CNAME"
      name    = "_acme-challenge.${local.niks3_server_domain}"
      value   = local.op_nix_cache_secrets["Fly_domain_DNS"]["acme_challenge"]
      proxied = false
    }
  }

  github_username = data.github_user.me.username
  github_repo_names = toset([
    "${local.github_username}/nix-cache",
    "${local.github_username}/home-server-nixos"
  ])

  niks3_server_domain = "niks3.${data.cloudflare_zone.main.name}"
  niks3_server_url    = "https://${local.niks3_server_domain}"
  niks3_api_token     = local.op_nix_cache_secrets["Niks3"]["api_token"]
  niks3_oidc = {
    providers : {
      github : {
        issuer : "https://token.actions.githubusercontent.com",
        audience : local.niks3_server_url,
        bound_claims : {
          repository_owner : [
            local.github_username
          ]
        },
        bound_subject : [for repo in data.github_repository.managed : "repo:${repo.full_name}:*"]
      }
    }
  }
  niks3_oidc_json        = jsonencode(local.niks3_oidc)
  niks3_oidc_json_base64 = base64encode(local.niks3_oidc_json)
}
