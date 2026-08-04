# Azure

resource "azuread_application_flexible_federated_identity_credential" "amiasea_sovereign_tfc_oidc" {
  application_id = azuread_application.amiasea_authority.id

  display_name = "amiasea-sovereign-tfc-oidc"

  description = "Flexible OIDC federation for Amiasea Sovereign TFC Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:sovereign:stack:sovereign:*'"
}

# AWS

# GCP