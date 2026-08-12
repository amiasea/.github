# Azure

data "azurerm_key_vault" "sovereign_kv" {
  name                = var.sovereign_azure_key_vault_name
  resource_group_name = var.sovereign_azure_resource_group_name
}

resource "azurerm_role_assignment" "automation_oidc_key_vault_reader" {
  scope                = data.azurerm_key_vault.sovereign_kv.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

resource "azurerm_role_assignment" "automation_oidc_key_vault_secrets_user" {
  scope                = data.azurerm_key_vault.sovereign_kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

# AWS

# GCP