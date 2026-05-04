resource "github_actions_variable" "niks3_server_url" {
  repository    = data.github_repository.nix_cache.name
  variable_name = "NIKS3_SERVER_URL"
  value         = local.fly_app_url
}

resource "github_actions_secret" "niks3_api_token" {
  repository      = data.github_repository.nix_cache.name
  secret_name     = "NIKS3_API_TOKEN"
  plaintext_value = local.niks3_api_token
}
