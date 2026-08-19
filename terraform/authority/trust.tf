# Azure

resource "azuread_application_flexible_federated_identity_credential" "amiasea_tfc_oidc" {
  application_id = azuread_application.amiasea_authority.id

  display_name = "amiasea-tfc-oidc"

  description = "Flexible OIDC federation for Amiasea TFC Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:*:workspace:*:run_phase:*'"
}

# AWS

# GCP