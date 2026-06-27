# ==============================================================================
# SECTION 1: TOP LEVEL ORGANIZATION AND PROJECTS
# ==============================================================================

data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_project" "amiasea_project" {
  name         = "amiasea"
  organization = "amiasea"
}

resource "tfe_project" "providers_project" {
  name         = "providers"
  organization = "amiasea"
  description  = "Global isolated home for custom provider scaffolding stacks"
}

resource "tfe_workspace" "workspace_dev" {
  name         = "amiasea-dev"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea_project.id
}

resource "tfe_workspace" "workspace_prod" {
  name         = "amiasea-prod"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea_project.id
}


# ==============================================================================
# SECTION 3: GROUP A - CROSS-PROJECT SHARED VARIABLE BUCKET
# ==============================================================================

# Container definition (Organization owned)
resource "tfe_variable_set" "shared_bootstrap_set" {
  name         = "Shared Bootstrap Varset"
  organization = "amiasea"
  global       = false
}

# Link 1: Exposes the bucket to traditional Workspaces in the core project
resource "tfe_project_variable_set" "amiasea_to_shared_bootstrap_project_link" {
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
  project_id      = data.tfe_project.amiasea_project.id
}

# Link 2: Exposes the exact same bucket to HCP Stacks in the new providers project
resource "tfe_project_variable_set" "providers_to_shared_bootstrap_project_link" {
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
  project_id      = tfe_project.providers_project.id
}

# --- Cross-Project Global Variables Allocation ---

resource "tfe_variable" "sovereign_key_vault_id" {
  key             = "sovereign_key_vault_id"
  value           = azurerm_key_vault.sovereign_vault.id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "sovereign_azure_tenant_id" {
  key             = "sovereign_azure_tenant_id"
  value           = var.tenant_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "sovereign_azure_subscription_id" {
  key             = "sovereign_azure_subscription_id"
  value           = var.subscription_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "sovereign_azure_client_id" {
  key             = "sovereign_azure_client_id"
  value           = azuread_application.delegated_permissions.client_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "sovereign_resource_group_name" {
  key             = "sovereign_resource_group_name"
  value           = var.resource_group_name
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "location" {
  key             = "location"
  value           = var.location
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "sql_admins_group_id" {
  key             = "sql_admins_group_id"
  value           = azuread_group.sql_admins.object_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "neon_project_id" {
  key             = "neon_project_id"
  value           = var.neon_project_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "aviator_gh_app_id" {
  key             = "amiasea_gh_app_id"
  value           = "2670685"
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "amiasea_private_key_id" {
  key             = "amiasea_private_key_versionless_id"
  value           = azurerm_key_vault_secret.amiasea_github_private_key.versionless_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

resource "tfe_variable" "ghcr_pat_id" {
  key             = "ghcr_pat_versionless_id"
  value           = azurerm_key_vault_secret.ghcr_pat.versionless_id
  category        = "terraform"
  sensitive       = true
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}


# ==============================================================================
# SECTION 4: GROUP B - CORE AMIASEA PROJECT VARIABLE BUCKET
# ==============================================================================

resource "tfe_variable_set" "amiasea_variable_set" {
  name              = "Amiasea Varset"
  description       = "Secrets scoped to the Amiasea project"
  organization      = "amiasea"
  parent_project_id = data.tfe_project.amiasea_project.id
  global            = false
}

resource "tfe_project_variable_set" "amiasea_project_link" {
  variable_set_id = tfe_variable_set.amiasea_variable_set.id
  project_id      = data.tfe_project.amiasea_project.id
}

resource "tfe_variable_set" "providers_variable_set" {
  name              = "Providers Varset"
  organization      = "amiasea"
  description       = "Houses the global Key Vault and OIDC properties for provider pipelines"
  parent_project_id = tfe_project.providers_project.id
  global            = false
}

resource "tfe_project_variable_set" "providers_project_link" {
  variable_set_id = tfe_variable_set.providers_variable_set.id
  project_id      = tfe_project.providers_project.id
}

resource "tfe_stack" "provider_stack" {
  name         = "providers"
  project_id   = tfe_project.providers_project.id
  description  = "Continuous Delivery Stack for custom terraform providers"
}