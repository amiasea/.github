# Azure

resource "azuread_application_flexible_federated_identity_credential" "amiasea_environment_tfc_oidc" {
  application_id = azuread_application.amiasea_authority.id

  display_name = "amiasea-environment-tfc-oidc"

  description = "Flexible OIDC federation for Amiasea Environment TFC Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:amiasea:workspace:environment:run_phase:*'"
}

resource "azuread_application_flexible_federated_identity_credential" "amiasea_delegation_tfc_oidc" {
  application_id = azuread_application.amiasea_authority.id

  display_name = "amiasea-delegation-tfc-oidc"

  description = "Flexible OIDC federation for Amiasea Delegation TFC Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:amiasea:workspace:delegation:run_phase:*'"
}

resource "azuread_application_flexible_federated_identity_credential" "amiasea_strata_tfc_oidc" {
  application_id = azuread_application.amiasea_authority.id

  display_name = "amiasea-strata-tfc-oidc"

  description = "Flexible OIDC federation for Amiasea Strata TFC Terraform."

  issuer = "https://app.terraform.io"

  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:amiasea:workspace:strata:run_phase:*'"
}

# AWS

# GCP