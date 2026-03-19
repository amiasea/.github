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

# resource "azapi_resource" "external_tenant" {
# #   for_each  = toset(var.environments)
#   type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2023-05-17-preview"
#   name      = "aviatortenanttest.onmicrosoft.com"
#   parent_id = data.azurerm_resource_group.rg.id
#   ignore_casing = true

#   schema_validation_enabled = false
#   location                  = "United States"

#     body = merge(
#     {
#       properties = merge(
#         {
#           createTenantProperties = {
#             countryCode = "US"
#             displayName = "Aviator Test"
#           }

#           billingConfig = {
#             billingType = "MAU"
#           }
#         },
#         {
#             initialDomainAdministrator = {
#                 userPrincipalName = "alfredo.ball@amiasea.onmicrosoft.com"
#                 displayName       = "Alfredo Ball"
#                 # passwordProfile = {
#                 #     password                      = var.initial_domain_administrator.password
#                 #     forceChangePasswordNextSignIn = true
#                 # }
#                 # accountEnabled = true
#             }
#         }
#       )

#       sku = {
#         name = "Base"
#         tier = "A0"
#       }
#     }
#   )

#   timeouts {
#     create = "30m"
#     update = "30m"
#     delete = "30m"
#   }

#   response_export_values = [
#     "properties.tenantId",
#     "properties.domainName",
#     "properties.provisioningState"
#   ]
# }

resource "azapi_resource_action" "external_tenant_post" {
  type        = "Microsoft.AzureActiveDirectory/ciamDirectories@2023-05-17-preview"
  resource_id = "/subscriptions/bd0f2cca-0676-49e6-a8c2-cae21ea7216b/resourceGroups/rg-amiasea-dev/providers/Microsoft.AzureActiveDirectory/ciamDirectories/aviatortenanttest.onmicrosoft.com"
  method      = "PUT"

  # Removed jsonencode() - version 2.0+ requires a raw HCL object
  body = {
    location = "United States"
    sku = {
      name = "Base"
      tier = "A0"
    }
    properties = {
      createTenantProperties = {
        displayName = "Aviator Test"
        countryCode = "US"
      }
      billingConfig = {
        billingType = "MAU"
      }
      initialDomainAdministrator = {
        userPrincipalName = "alfredo.ball@amiasea.onmicrosoft.com"
        displayName       = "Alfredo Ball"
      }
    }
  }

  response_export_values = [
    "properties.tenantId",
    "properties.domainName",
    "properties.provisioningState"
  ]

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}
