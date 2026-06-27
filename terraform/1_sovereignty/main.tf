data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "azurerm_subscription" "amiasea" {
  subscription_id = var.subscription_id
}

data "azurerm_subscriptions" "search" {
  display_name_prefix = "${var.prefix}-"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "github_actions_organization_oidc_subject_claim_customization_template" "main" {
  # This tells GitHub to pack these specific pieces of data into the 'sub' claim
  include_claim_keys = [
    "repo",
    "job_workflow_ref",
    "context"
  ]
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "sovereign" {
  repository  = ".github"
  use_default = false

  # Use the Organization's template, 
  # Leave include_claim_keys empty to inherit it.
  include_claim_keys = [
    "job_workflow_ref",
  ]
}

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

  resource "azurerm_role_assignment" "terraform_kv_admin" {
    scope                = azurerm_key_vault.sovereign_vault.id
    role_definition_name = "Key Vault Administrator"
    principal_id         = data.azurerm_client_config.current.object_id
  }

resource "azurerm_role_assignment" "vending_secrets_power" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}