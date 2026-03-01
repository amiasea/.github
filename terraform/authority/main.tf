# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = "kv-amiasea"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_role_assignment" "vault_reader" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.uami_read_principal_id
}

resource "azurerm_role_assignment" "vault_writer" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = var.uami_write_principal_id
}