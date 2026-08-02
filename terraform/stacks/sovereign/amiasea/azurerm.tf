resource "azurerm_user_assigned_identity" "uami_amiasea_automation_oidc" {
  name                = "uami-amiasea-stacks-oidc"
  resource_group_name = var.resource_group_name
  location            = var.location
}

data "azurerm_key_vault" "sovereign_key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "stacks_oidc_key_vault_reader" {
  scope                = data.azurerm_key_vault.sovereign_key_vault.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

resource "azurerm_role_assignment" "stacks_oidcs_key_vault_secrets_user" {
  scope                = data.azurerm_key_vault.sovereign_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.principal_id
}

resource "azurerm_federated_identity_credential" "iac_module_catalog_github_actions_credential" {
  name                      = "iac-module-catalog-github-actions-credential"
  user_assigned_identity_id = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.id

  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:amiasea@254765293/iac-module-catalog@1317465381:ref:refs/heads/main"
  audience = ["api://AzureADTokenExchange"]

  depends_on = [
    azurerm_user_assigned_identity.uami_amiasea_automation_oidc,
    github_repository.iac_module_catalog
  ]
}