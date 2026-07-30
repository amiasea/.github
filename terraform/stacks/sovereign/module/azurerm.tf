resource "azurerm_user_assigned_identity" "uami_amiasea_stack_oidc" {
  name                = "uami-amiasea-stack-oidc"
  resource_group_name = var.resource_group_name
  location            = var.location
}

data "azurerm_key_vault" "sovereign_key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

resource "azurerm_role_assignment" "stack_oidc_key_vault_reader" {
  scope                = data.azurerm_key_vault.sovereign_key_vault.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.principal_id
}

resource "azurerm_role_assignment" "stack_oidc_key_vault_secrets_user" {
  scope                = data.azurerm_key_vault.sovereign_key_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.principal_id
}

resource "azurerm_federated_identity_credential" "amiasea_stacks" {
  name                      = "edm-installation-registry-plan"
  user_assigned_identity_id = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.id

  issuer   = "https://app.terraform.io"
  subject  = "organization:amiasea:project:amiasea:stack:*:deployment:*:operation:*"
  audience = ["api://AzureADTokenExchange"]
}