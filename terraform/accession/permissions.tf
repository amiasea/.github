resource "azurerm_role_assignment" "authority_managed_identity_contributor" {
  scope                = azurerm_resource_group.amiasea_sovereign_rg.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}

resource "azurerm_role_assignment" "authority_stack_rbac_admin" {
  scope                = azurerm_resource_group.amiasea_sovereign_rg.id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = azuread_service_principal.amiasea_authority_sp.object_id
}