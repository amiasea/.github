resource "azuread_application" "amiasea_sovereign" {
  display_name = "Amiasea-Sovereign"
}

resource "azuread_service_principal" "amiasea_sovereign_sp" {
  client_id = azuread_application.amiasea_sovereign.client_id
}

resource "azuread_application_flexible_federated_identity_credential" "hcp_stacks" {
  application_id = azuread_application.amiasea_sovereign.id
  display_name   = "hcp-stacks"
  description    = "Flexible OIDC for HCP Terraform Stacks"

  issuer   = "https://app.terraform.io"
  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:amiasea:stack:sovereign:operation:*'"
}