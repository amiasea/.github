data "azapi_resource" "ciam_tenant" {
  type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
  name      = "aviatortenant${var.env}.onmicrosoft.com"
  parent_id = data.azurerm_resource_group.rg.id
}

resource "azuread_user_flow_attribute" "organization" {
  provider     = azuread.ciam
  display_name = "Organization"
  data_type    = "string"
  description  = "Company or Org name"
}