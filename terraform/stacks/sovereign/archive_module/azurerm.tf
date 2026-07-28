data "azurerm_client_config" "current" {}

data "azurerm_subscription" "amiasea" {
  subscription_id = data.tfe_outputs.sovereign_workspace.nonsensitive_values.subscription_id
}

data "azurerm_subscriptions" "search" {
  display_name_prefix = "${var.organization_name}-"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_service_principal" "delegated_permissions_sp" {
  client_id = azuread_application.delegated_permissions.client_id
}

resource "azuread_directory_role" "app_admin" {
  display_name = "Application Administrator"
}

resource "azuread_directory_role" "external_id_user_flow_admin" {
  display_name = "External ID User Flow Administrator"
}

resource "azuread_directory_role" "external_id_user_flow_attr_admin" {
  display_name = "External ID User Flow Attribute Administrator"
}

resource "azuread_directory_role_assignment" "app_admin" {
  role_id             = azuread_directory_role.app_admin.template_id
  principal_object_id = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azuread_directory_role_assignment" "external_id_user_flow_admin" {
  role_id             = azuread_directory_role.external_id_user_flow_admin.template_id
  principal_object_id = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azuread_directory_role_assignment" "external_id_user_flow_attr_admin" {
  role_id             = azuread_directory_role.external_id_user_flow_attr_admin.template_id
  principal_object_id = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_kv_secrets_user" {
  scope                = azurerm_key_vault.sovereign_vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_creator" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_contributor" {
  for_each = { for sub in data.azurerm_subscriptions.search.subscriptions : sub.subscription_id => sub }

  scope                = "/subscriptions/${each.key}"
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_kv_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

# Give this global App Registration full admin rights over just this specific vault
resource "azurerm_role_assignment" "global_app_kv_admin" {
  scope                = azurerm_key_vault.sovereign_vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_user_access_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "sp_sub_contributor" {
  for_each = toset(var.environments)

  # Scope is the ENTIRE new subscription
  scope                = "/subscriptions/${azurerm_subscription.env_sub[each.value].subscription_id}"
  role_definition_name = "Contributor"
  
  # This is the Object ID of your GitHub OIDC Service Principal
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}