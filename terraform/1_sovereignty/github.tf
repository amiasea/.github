resource "github_actions_variable" "arm_client_id" {
  repository    = ".github"
  variable_name = "AZURE_CLIENT_ID"
  value         = azuread_service_principal.delegated_permissions_sp.client_id
}

resource "github_actions_variable" "arm_tenant_id" {
  repository    = ".github"
  variable_name = "AZURE_TENANT_ID"
  value         = data.azurerm_client_config.current.tenant_id
}

resource "github_actions_variable" "arm_subscription_id" {
  repository    = ".github"
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value         = data.azurerm_client_config.current.subscription_id
}

resource "github_actions_variable" "amiasea_gh_app_id" {
  repository    = ".github"
  variable_name = "AMIASEA_GH_APP_ID"
  value         = "2670685"
}

resource "github_actions_variable" "amiasea_private_key_versionless_id" {
  repository    = ".github"
  variable_name = "AMIASEA_PRIVATE_KEY_VERSIONLESS_ID"
  value         = azurerm_key_vault_secret.amiasea_github_private_key.versionless_id
}

resource "github_actions_variable" "tf_token_versionless_id" {
  repository    = ".github"
  variable_name = "TF_TOKEN_VERSIONLESS_ID"
  value         = azurerm_key_vault_secret.tf_token.versionless_id
}

resource "github_actions_organization_variable" "tf_provider_stack_id" {
  visibility    = "all"
  variable_name = "TF_PROVIDER_STACK_ID"
  value         = tfe_stack.provider_stack.id
}