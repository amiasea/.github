# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = "kv-amiasea"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
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

resource "azuread_directory_role_assignment" "write_uami_app_admin" {
  role_id             = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" # Application Administrator
  principal_object_id = var.uami_write_principal_id
}