data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_role_assignment" "sovereign_stack_key_vault_reader" {
  scope                = azurerm_key_vault.sovereign_vault.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.amiasea_sovereign_sp.object_id
}

resource "azurerm_role_assignment" "sovereign_stack_key_vault_secrets_user" {
  scope                = azurerm_key_vault.sovereign_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.amiasea_sovereign_sp.object_id
}