data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_service_principal" "amiasea_sovereign_sp" {
  client_id = azuread_application.amiasea_sovereign.client_id
}

resource "azurerm_role_assignment" "sovereign_stack_key_vault_secrets_user" {
  scope                = azurerm_key_vault.sovereign_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.amiasea_sovereign_sp.object_id
}