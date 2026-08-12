data "tfe_organization" "amiasea_tfe_org" {
  name = "amiasea"
}

data "azurerm_client_config" "current" {}

ephemeral "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  name         = "amiasea-tfe-org-token"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name         = "amiasea-github-app-private-key"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id
}
