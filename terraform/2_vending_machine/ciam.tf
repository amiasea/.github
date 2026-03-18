data "azapi_resource" "ciam_tenant" {
  type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
  name      = "aviatortenant${var.env}.onmicrosoft.com"
  parent_id = data.azurerm_resource_group.rg.id

  response_export_values = ["*"]
}

resource "azuread_user_flow_attribute" "organization" {
  provider     = azuread.ciam
  display_name = "Organization"
  data_type    = "string"
  description  = "Company or Org name"
}

output "ciam_tenant_id" {
  # Now that we're catching the values, we can parse the string
  value = jsondecode(data.azapi_resource.ciam_tenant.output).properties.tenantId
}