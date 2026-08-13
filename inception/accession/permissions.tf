data "azurerm_billing_mca_account_scope" "amiasea" {
  billing_account_name = "e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31"
  billing_profile_name = "MUGO-ML6Y-BG7-PGB"
  invoice_section_name = "V4EB-6NK3-PJA-PGB"
}

resource "azapi_resource_action" "authority_subscription_creator" {
  type        = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections@2024-04-01"
  resource_id = data.azurerm_billing_mca_account_scope.amiasea.id
  action      = "createBillingRoleAssignment"
  method      = "POST"

  body = {
    principalId       = azuread_service_principal.amiasea_authority_sp.object_id
    principalTenantId = data.azurerm_client_config.current.tenant_id
    roleDefinitionId  = "${data.azurerm_billing_mca_account_scope.amiasea.id}/billingRoleDefinitions/30000000-aaaa-bbbb-cccc-100000000006"
  }
  response_export_values = ["id"]
}

resource "azapi_resource_action" "delete_billing_role" {
  # This resource type points directly to the billing assignments endpoint
  type        = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/billingRoleAssignments@2024-04-01"
  
  # Dynamically pull the assignment ID exported from the previous resource block
  resource_id = azapi_resource_action.authority_subscription_creator.output.id
  method      = "DELETE"

  # Tells Terraform to completely ignore this on apply, and only trigger it on destroy
  when = "destroy"
}