resource "github_actions_variable" "niks3_server_url" {
  for_each      = data.github_repository.managed
  repository    = each.value.name
  variable_name = "NIKS3_SERVER_URL"
  value         = local.fly_app_url
}

resource "github_actions_secret" "niks3_api_token" {
  for_each        = data.github_repository.managed
  repository      = each.value.name
  secret_name     = "NIKS3_API_TOKEN"
  plaintext_value = local.niks3_api_token
}
