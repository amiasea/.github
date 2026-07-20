resource "azuread_application_flexible_federated_identity_credential" "sovereign" {
  application_id = azuread_application.delegated_permissions.id
  display_name   = "vending-machine-lock"
  description    = "Flexible OIDC for GitHub Actions"

  issuer   = "https://token.actions.githubusercontent.com"
  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches '*job_workflow_ref:amiasea/.github/.github/workflows/vending-machine.yml@refs/heads/main*'"
}

resource "azuread_application_flexible_federated_identity_credential" "hcp_stacks" {
  application_id = azuread_application.delegated_permissions.id
  display_name   = "hcp-stacks"
  description    = "Flexible OIDC for HCP Terraform Stacks"

  issuer   = "https://app.terraform.io"
  audience = "api://AzureADTokenExchange"

  claims_matching_expression = "claims['sub'] matches 'organization:amiasea:project:amiasea:stack:*:operation:*'"
}

resource "azuread_application" "delegated_permissions" {
  display_name = "Amiasea-Delegated-Permissions-App"
}