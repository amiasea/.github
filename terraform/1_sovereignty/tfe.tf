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

data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}

# 2. Create the variable set (it must NOT be global)
resource "tfe_variable_set" "stack_variable_set" {
  name          = "Stack-Specific Credentials"
  description   = "Secrets scoped to the Spire infrastructure project"
  organization  = "amiasea"
  global        = false 
}

# 3. Apply the set to the PROJECT (This gives Stacks inside access)
resource "tfe_project_variable_set" "project_link" {
  variable_set_id = tfe_variable_set.stack_variable_set.id
  project_id      = data.tfe_project.amiasea.id
}

resource "tfe_variable" "sql_admins_group_id" {
  key             = "sql_admins_group_id"
  value           = azuread_group.sql_admins.object_id
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "tenant_id" {
  key             = "ARM_TENANT_ID"
  value           = data.azurerm_client_config.current.tenant_id
  category        = "env" # Environment variable for Azure Provider
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "subscription_id" {
  key             = "ARM_SUBSCRIPTION_ID"
  value           = data.azurerm_client_config.current.subscription_id
  category        = "env" # Environment variable for Azure Provider
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "resource_group_name" {
  key             = "resource_group_name"
  value           = var.resource_group_name
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "location" {
  key             = "location"
  value           = var.location
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "client_id" {
  key             = "ARM_CLIENT_ID"
  value           = azuread_service_principal.delegated_permissions_sp.client_id
  category        = "env" # Environment variable for Azure Provider
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "aviator_gh_app_id" {
  key             = "amiasea_gh_app_id"
  value           = "2670685"
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "amiasea_private_key_id" {
  key             = "amiasea_private_key_versionless_id"
  value           = azurerm_key_vault_secret.amiasea_github_private_key.versionless_id
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "tf_token_id" {
  key             = "tf_token_versionless_id"
  value           = azurerm_key_vault_secret.tf_token.versionless_id
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "ghcr_pat_id" {
  key             = "ghcr_pat_versionless_id"
  value           = azurerm_key_vault_secret.ghcr_pat.versionless_id
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.stack_variable_set.id
}

resource "tfe_variable" "sovereign_key_vault_id" {
  key             = "sovereign_key_vault_id"
  value           = azurerm_key_vault.vault.id
  category        = "env"
  variable_set_id = tfe_variable_set.stack_variable_set.id
}
