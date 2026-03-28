data "azurerm_billing_mca_account_scope" "billing_scope" {
  billing_account_name = var.billing_account_id
  billing_profile_name = var.billing_profile_id
  invoice_section_name = var.billing_profile_invoice_section_id
}

resource "azurerm_subscription" "env_sub" {
  for_each          = toset(var.environments)
  alias             = "${var.prefix}-${each.value}"
  subscription_name = "${var.prefix}-${each.value}"
  billing_scope_id  = data.azurerm_billing_mca_account_scope.billing_scope.id

  workload = "Production"

  lifecycle {
    ignore_changes = [workload]
  }
}

resource "azapi_resource" "rg_env" {
  for_each  = toset(var.environments)
  type      = "Microsoft.Resources/resourceGroups@2021-04-01"
  name      = "rg-${var.prefix}-${each.value}"
  location  = var.location
  parent_id = "/subscriptions/${azurerm_subscription.env_sub[each.value].subscription_id}"
}

resource "azapi_resource" "external_tenant" {
  for_each  = toset(var.environments)
  type      = "Microsoft.AzureActiveDirectory/ciamDirectories@2025-08-01-preview"
  name      = "aviatortenant${each.value}.onmicrosoft.com"
  parent_id = azapi_resource.rg_env[each.value].id
  ignore_casing = true

  schema_validation_enabled = false
  location                  = "United States"

  body = {
    sku = { name = "Base", tier = "A0" }
    properties = {
      createTenantProperties = {
        displayName = "Aviator ${title(each.value)}"
        countryCode = "US"
      },
      initialDomainAdministrator = {
        userPrincipalName = var.initial_domain_administrator.user_principal_name
        displayName       = var.initial_domain_administrator.display_name
        passwordProfile = {
          password                      = var.initial_domain_administrator.password
          forceChangePasswordNextSignIn = true
        }
        accountEnabled = true
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