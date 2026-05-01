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
      "com.cloudflare.edge.r2.bucket.${local.cf_account_id}_default_${cloudflare_r2_bucket.bucket.name}" = "*"
    })
  }]
}

resource "onepassword_item" "cloudflare_r2" {
  vault    = data.onepassword_vault.homelab.uuid
  title    = "Cloudflare_R2_Nix_Cache"
  category = "secure_note"

  tags = ["Managed By Terraform"]

  section {
    label = "S3_API"

    field {
      label = "access_key_id"
      type  = "STRING"
      value = local.r2_bucket_access_key_id
    }

    field {
      label = "access_key_secret"
      type  = "CONCEALED"
      value = local.r2_bucket_access_key_secret
    }
  }

}
