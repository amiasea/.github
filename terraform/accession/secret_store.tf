resource "azurerm_resource_group" "amiasea_sovereign_rg" {
  name     = var.sovereign_azure_resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "sovereign_kv" {
  name                = var.sovereign_azure_key_vault_name
  location            = var.location
  resource_group_name = azurerm_resource_group.amiasea_sovereign_rg.name

  tenant_id = var.authority_azure_tenant_id

  sku_name = "standard"

  # Security boundary
  rbac_authorization_enabled = true
  # Prevent accidental destruction
  purge_protection_enabled   = false
  soft_delete_retention_days = 90

  # Network posture
  public_network_access_enabled = true

  # Allow Azure services that require Key Vault access
  enabled_for_disk_encryption = false
  enabled_for_deployment      = false
  enabled_for_template_deployment = false

  depends_on = [ azurerm_resource_group.amiasea_sovereign_rg ]
}

resource "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  name = "amiasea-tfe-org-token"

  value_wo = var.amiasea_tfe_org_token
  value_wo_version = 1

  key_vault_id = azurerm_key_vault.sovereign_kv.id
}

resource "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name = "amiasea-github-app-private-key"

  value_wo = var.amiasea_github_app_private_key
  value_wo_version = 1

  key_vault_id = azurerm_key_vault.sovereign_kv.id
}