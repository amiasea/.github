module "speculative" {
  source = "./speculative"

  providers = {
    azurerm = azurerm.speculative
  }
}

data "azurerm_key_vault" "sovereign_kv" {
  provider = azurerm.institutive
  name                = "kv-amiasea-sovereign"
  resource_group_name = "rg-amiasea-sovereign"
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  provider = azurerm.institutive
  name         = "amiasea-github-app-private-key"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id
}

ephemeral "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  provider = azurerm.institutive
  name         = "amiasea-tfe-org-token"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id
}