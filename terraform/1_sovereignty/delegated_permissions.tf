resource "azuread_application" "delegated_permissions" {
  display_name = "Amiasea-Delegated-Permissions-App"
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
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_creator" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

# resource "azurerm_role_assignment" "delegated_permissions_app_contributor" {
#   scope                = data.azurerm_subscription.amiasea.id
#   role_definition_name = "Contributor"
#   principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
# }

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

resource "azapi_resource_action" "sp_billing_assignment_private" {
  resource_id = "/providers/Microsoft.Billing/billingAccounts/e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31/billingProfiles/MUGO-ML6Y-BG7-PGB/invoiceSections/V4EB-6NK3-PJA-PGB"

  # Not generally available but it's what the Portal is using (Otherwise you can't assign the Azure subscription creator role to a SP)
  type   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections@2020-12-15-privatepreview"
  action = "createBillingRoleAssignment"
  method = "POST"

  # Flat payload exactly like the portal's request content
  body = {
    principalId      = azuread_service_principal.delegated_permissions_sp.object_id
    roleDefinitionId = "/providers/Microsoft.Billing/billingAccounts/e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31/billingProfiles/MUGO-ML6Y-BG7-PGB/invoiceSections/V4EB-6NK3-PJA-PGB/billingRoleDefinitions/30000000-aaaa-bbbb-cccc-100000000006"
  }
}