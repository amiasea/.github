resource "github_actions_variable" "azure_client_id" {
  repository = data.github_repository.enterprise_strata.name
  variable_name = "AZURE_CLIENT_ID"
  value = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.client_id
}

resource "github_actions_variable" "azure_tenant_id" {
  repository = data.github_repository.enterprise_strata.name
  variable_name = "AZURE_TENANT_ID"
  value = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_variable" "azure_subscription_id" {
  repository = data.github_repository.enterprise_strata.name
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value = data.azurerm_client_config.current.subscription_id
}

resource "github_actions_variable" "azure_key_vault_name" {
  repository = data.github_repository.enterprise_strata.name
  variable_name = "AZURE_KEY_VAULT_NAME"
  value = var.sovereign_azure_key_vault_name
}