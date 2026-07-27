# --- SOVEREIGN KEY VAULT ---

resource "azurerm_key_vault" "sovereign_vault" {
  name                = var.key_vault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
  rbac_authorization_enabled = true

  network_acls {
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "github_app_private_key" {
  name             = "amiasea-github-private-key"
  value_wo         = var.github_app_private_key
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}

resource "azurerm_key_vault_secret" "tfe_org_token" {
  name             = "tfe-org-token"
  value_wo         = var.tfe_org_token
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}