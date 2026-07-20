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