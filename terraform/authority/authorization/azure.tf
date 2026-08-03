resource "azurerm_role_assignment" "sovereign_managed_identity_contributor" {
  scope                = var.sovereign_resource_group_id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = var.sovereign_principal_id
}

resource "azurerm_role_assignment" "sovereign_stack_rbac_admin" {
  scope                = var.sovereign_resource_group_id
  role_definition_name = "Role Based Access Control Administrator"
  principal_id         = var.sovereign_principal_id
}

resource "azurerm_role_assignment" "sovereign_stack_key_vault_reader" {
  scope                = var.sovereign_key_vault_id
  role_definition_name = "Reader"
  principal_id         = var.sovereign_principal_id
}

resource "azurerm_role_assignment" "sovereign_stack_key_vault_secrets_user" {
  scope                = var.sovereign_key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.sovereign_principal_id
}