# Azure

resource "azurerm_role_assignment" "automation_oidc_key_vault_reader" {
  scope                = var.sovereign_azure_key_vault_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

resource "azurerm_role_assignment" "automation_oidc_key_vault_secrets_user" {
  scope                = var.sovereign_azure_key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

# AWS

# GCP