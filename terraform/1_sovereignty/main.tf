data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "http" "my_public_ip" {
  url = "https://ifconfig.me"
}

data "azurerm_subscription" "amiasea" {
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

data "azurerm_billing_mca_account_scope" "billing_scope" {
  billing_account_name = var.billing_account_id
  billing_profile_name = var.billing_profile_id
  invoice_section_name = var.billing_profile_invoice_section_id
}

resource "azuread_application" "delegated_permissions" {
  display_name = "Amiasea-Delegated-Permissions-App"
}

resource "azuread_service_principal" "delegated_permissions_sp" {
  client_id = azuread_application.delegated_permissions.client_id
}

resource "azuread_directory_role" "app_admin" {
  display_name = "Application Administrator"
}

resource "azuread_directory_role" "tenant_creator" {
  display_name = "Tenant Creator"
}

resource "azuread_directory_role_assignment" "app_admin" {
  role_id             = azuread_directory_role.app_admin.template_id
  principal_object_id = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azuread_directory_role_assignment" "tenant_creator" {
  role_id             = azuread_directory_role.tenant_creator.template_id
  principal_object_id = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azapi_resource_action" "sp_billing_assignment_private" {
  resource_id = "/providers/Microsoft.Billing/billingAccounts/e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31/billingProfiles/MUGO-ML6Y-BG7-PGB/invoiceSections/V4EB-6NK3-PJA-PGB"

  # Not generally available but it's what the Portal is using (Otherwise you can't assign the Azure subscription creator role to a SP)
  type   = "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections@2020-12-15-privatepreview"
  action = "createBillingRoleAssignment"
  method = "POST"

  # Flat payload exactly like the portal's request content
  body = {
    principalId      = "dd22011c-712e-4738-a1cf-fec01e03e11f"
    roleDefinitionId = "/providers/Microsoft.Billing/billingAccounts/e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31/billingProfiles/MUGO-ML6Y-BG7-PGB/invoiceSections/V4EB-6NK3-PJA-PGB/billingRoleDefinitions/30000000-aaaa-bbbb-cccc-100000000006"
  }
}

resource "azurerm_role_assignment" "delegated_permissions_app_kv_secrets_user" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_creator" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_contributor" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_kv_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}

resource "azurerm_role_assignment" "delegated_permissions_app_user_access_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "User Access Administrator"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
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

data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}

resource "tfe_workspace" "workspace_dev" {
  name         = "amiasea-dev"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

resource "tfe_workspace" "workspace_prod" {
  name         = "amiasea-prod"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}
