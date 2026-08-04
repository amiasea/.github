resource "azurerm_role_assignment" "authority_managed_identity_contributor" {
  scope                = azurerm_resource_group.amiasea_sovereign_rg.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}

resource "azurerm_role_assignment" "authority_rbac_admin" {
  scope                = azurerm_resource_group.amiasea_sovereign_rg.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}

resource "azurerm_role_assignment" "authority_key_vault_reader" {
  scope                = azurerm_key_vault.sovereign_kv.id
  role_definition_name = "Reader"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}

resource "azurerm_role_assignment" "authority_key_vault_secrets_user" {
  scope                = azurerm_key_vault.sovereign_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}