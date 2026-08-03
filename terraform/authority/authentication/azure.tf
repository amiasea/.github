resource "azuread_application" "amiasea_sovereign" {
  display_name = "Amiasea-Sovereign"
}

resource "azuread_service_principal" "amiasea_sovereign_sp" {
  client_id = azuread_application.amiasea_sovereign.client_id
}

resource "azurerm_resource_group" "amiasea_sovereign_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azuread_application_flexible_federated_identity_credential" "amiasea_sovereign_hcp_oidc" {
  application_id = azuread_application.amiasea_sovereign.id

  display_name = "amiasea-sovereign-hcp-oidc"

  description = "Flexible OIDC federation for Amiasea Sovereign HCP Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:sovereign:stack:sovereign:*'"
}

output "sovereign_client_id" {
  value = azuread_application.amiasea_sovereign.client_id
}

output "sovereign_resource_group_id" {
  value = azurerm_resource_group.amiasea_sovereign_rg.id
}

output "sovereign_resource_group_name" {
  value = azurerm_resource_group.amiasea_sovereign_rg.name
}

output "sovereign_principal_id" {
  value = azuread_service_principal.amiasea_sovereign_sp.object_id
}