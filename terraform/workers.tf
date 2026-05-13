resource "cloudflare_worker" "niks3_redirects" {
  account_id = local.cf_account_id
  name       = "niks3-redirect-worker"
  observability = {
    enabled = true
    logs = {
      enabled = false
    }
    traces = {
      enabled = false
    }
  }
}

resource "cloudflare_worker_version" "niks3_redirects_version" {
  account_id         = local.cf_account_id
  worker_id          = cloudflare_worker.niks3_redirects.id
  compatibility_date = "2026-05-12"
  main_module        = "worker.js"
  modules = [
    {
      name         = "worker.js"
      content_type = "application/javascript+module"
      content_file = local.workers_script_path
    }
  ]

  bindings = [
    {
      name = "R2_BUCKET_PUBLIC_URL"
      text = local.r2_bucket_public_url
      type = "plain_text"
    }
  ]
}

resource "cloudflare_workers_deployment" "niks3_redirects_deployment" {
  account_id  = local.cf_account_id
  script_name = cloudflare_worker.niks3_redirects.name
  strategy    = "percentage"
  versions = [{
    percentage = 100
    version_id = cloudflare_worker_version.niks3_redirects_version.id
  }]
}

resource "cloudflare_workers_route" "niks3_redirects" {
  for_each = local.workers_handled_paths
  zone_id  = local.cf_zone_id
  pattern  = "${local.niks3_server_domain}/${each.value}"
  script   = cloudflare_worker.niks3_redirects.name
}
