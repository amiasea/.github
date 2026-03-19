# data "azapi_resource" "ciam_tenant" {
#   type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
#   name      = "aviatortenant${var.env}.onmicrosoft.com"
#   parent_id = data.azurerm_resource_group.rg.id

#   response_export_values = ["*"]
# }

# resource "azuread_user_flow_attribute" "organization" {
#   provider     = azuread.ciam
#   display_name = "Organization"
#   data_type    = "string"
#   description  = "Company or Org name"
# }

resource "azapi_resource" "external_tenant" {
#   for_each  = toset(var.environments)
  type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
  name      = "aviatortenanttest.onmicrosoft.com"
  parent_id = data.azurerm_resource_group.rg.id
  ignore_casing = true

  schema_validation_enabled = false
  location                  = "United States"

  body = {
    sku = { name = "Base", tier = "A0" }
    properties = {
      createTenantProperties = {
        displayName = "Aviator Test"
        countryCode = "US"
      },
      initialDomainAdministrator = {
        userPrincipalName = "alfredo.ball@amiasea.onmicrosoft.com"
        displayName       = "Alfredo Ball"
        # passwordProfile = {
        #   password                      = var.initial_domain_administrator.password
        #   forceChangePasswordNextSignIn = true
        # }
        # accountEnabled = true
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }

  response_export_values = [
    "properties.tenantId",
    "properties.domainName",
    "properties.provisioningState"
  ]
}