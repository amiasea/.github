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



resource "azuread_group" "sql_admins" {
  display_name     = "Amiasea-SQL-Admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "Members of this group are AD Admins for all vended SQL environments."
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

resource "azuread_application_federated_identity_credential" "hcp_stack" {
  application_id = azuread_application.delegated_permissions.id
  display_name   = "vending-machine-hcp-stack"
  description    = "Trust for HCP Terraform Stacks"
  
  # MUST be exactly this for HCP Terraform
  issuer   = "https://app.terraform.io"
  audiences = ["api://AzureADTokenExchange"]

  # Format: organization:<ORG>:project:<PROJ>:stack:<STACK>:deployment:<DEPLOY>:operation:<PLAN|APPLY|DESTROY>
  # You can use a wildcard (*) at the end if using 'flexible' version to cover plan/apply
  subject  = "organization:amiasea:project:amiasea:stack:Vending-Machine:deployment:prod:operation:apply"
}


# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
  rbac_authorization_enabled = true

  network_acls {
    # Poor Option
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}
resource "azurerm_role_assignment" "terraform_kv_admin" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_role_assignment" "vending_secrets_power" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}

resource "azurerm_key_vault_secret" "ghcr_pat" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "ghcr-pat"
  value_wo         = var.ghcr_pat
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "tf_token" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "tf-token"
  value_wo         = var.tf_token
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.vault.id
}

resource "azurerm_key_vault_secret" "amiasea_github_private_key" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "amiasea-github-private-key"
  value_wo         = var.amiasea_github_private_key
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.vault.id
}
