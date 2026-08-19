resource "azapi_resource" "sovereign_rg" {
  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  name      = "rg-amiasea-sovereign"
  location  = var.location
  parent_id = "/subscriptions/da348b35-29b6-4906-85ec-4a097aa5fe04"
}

resource "azurerm_key_vault" "sovereign_kv" {
  name                = "kv-amiasea-sovereign"
  location            = var.location
  resource_group_name = "rg-amiasea-sovereign"

  tenant_id = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  # Security boundary
  rbac_authorization_enabled = true
  # Prevent accidental destruction
  purge_protection_enabled   = false
  soft_delete_retention_days = 7

  # Network posture
  public_network_access_enabled = true

  # Allow Azure services that require Key Vault access
  enabled_for_disk_encryption = false
  enabled_for_deployment      = false
  enabled_for_template_deployment = false

  depends_on = [ azapi_resource.sovereign_rg ]
}

resource "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  name = "amiasea-tfe-org-token"

  value_wo = var.amiasea_tfe_org_token
  value_wo_version = 1

  key_vault_id = azurerm_key_vault.sovereign_kv.id

  depends_on = [ azurerm_key_vault.sovereign_kv ]
}

ephemeral "azurerm_key_vault_secret" "e_amiasea_tfe_org_token" {
  name         = "amiasea-tfe-org-token"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id

  depends_on = [ azurerm_key_vault_secret.amiasea_tfe_org_token ]
}

resource "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name = "amiasea-github-app-private-key"

  value_wo = var.amiasea_github_app_private_key
  value_wo_version = 1

  key_vault_id = azurerm_key_vault.sovereign_kv.id

  depends_on = [ azurerm_key_vault.sovereign_kv ]
}