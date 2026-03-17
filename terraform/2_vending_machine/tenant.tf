resource "azapi_resource" "external_tenant" {
  # Use the latest preview version you saw in your network tab
  type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
  
  # This must be the unique .onmicrosoft.com domain name
  name      = "aviatortenant-${var.env}.onmicrosoft.com"
  
  # This is the Resource Group ID from your PUT URL
  parent_id = "/subscriptions/da348b35-29b6-4906-85ec-4a097aa5fe04/resourceGroups/${azurerm_resource_group.rg}"

  location  = "United States"

  schema_validation_enabled = false

  # The exact JSON structure from your browser's dev tools
  body = {
    sku = {
      name = "Base"
      tier = "A0"
    }
    properties = {
      createTenantProperties = {
        displayName = "Aviator"
        countryCode = "US"
      }
    }
  }

  # This allows you to grab the New Tenant ID for the next steps
  response_export_values = ["properties.tenantId"]
}
