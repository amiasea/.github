data "github_app_token" "client" {
  app_id          = var.amiasea_gh_app_id
  installation_id = var.github_installation_id
  pem_file        = var.amiasea_gh_app_private_key
}

output "github_token" {
  value     = data.github_app_token.client.token
  sensitive = true
}