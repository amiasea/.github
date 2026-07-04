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

resource "tfe_project_variable_set" "amiasea_to_shared_bootstrap_project_link" {
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
  project_id      = data.tfe_project.amiasea_project.id
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

resource "tfe_variable" "tf_token_versionless_id" {
  key             = "tf_token_versionless_id"
  value           = azurerm_key_vault_secret.tf_token.versionless_id
  category        = "terraform"
  description     = "The versionless Key Vault API URI pointer reference for the core HCP Terraform authentication token."
  sensitive       = true
  variable_set_id = tfe_variable_set.shared_bootstrap_set.id
}

# ==============================================================================
# SECTION 5: MODULES & STACKS - DYNAMICALLY DISCOVERED AND CREATED
# ==============================================================================

data "tfe_github_app_installation" "amiasea_vcs" {
  # Pass your real 8-digit GitHub Organization App Installation ID
  installation_id = 117633797
  provider        = tfe.gh_app
}

locals {
    discovered_modules = toset([
    for path in fileset("${path.module}/../modules", "**/README.md") : basename(dirname(path))
  ])
  discovered_stacks = toset([
    for path in fileset("${path.module}/../stacks", "**/README.md") : basename(dirname(path))
  ])
}

resource "tfe_registry_module" "private_modules" {
  for_each = local.discovered_modules

  organization   = var.organization_name
  provider = tfe.gh_app
  module_provider = "amiasea"
  registry_name = "private"

  name         = "${each.key}"
  
  # Connects the module natively to the VCS provider
  vcs_repo {
    display_identifier         = "${each.key}"
    identifier                 = "amiasea/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.amiasea_vcs.id
    source_directory           = "terraform/modules/${each.key}"
    tag_prefix                 = "${each.key}-" 
  }
}















import {
  to = tfe_stack.stacks["vending_machine"]
  id = "st-o53cTwA1Z8QsKF2c"
  provider        = tfe.gh_app
}

import {
  to = tfe_stack.stacks["providers"]
  id = "st-Jsar3E2fmKbqWcKm" 
  provider        = tfe.gh_app
}

resource "tfe_stack" "stacks" {
  for_each    = local.discovered_stacks

  provider        = tfe.gh_app
  
  name        = each.value
  project_id  = data.tfe_project.amiasea_project.id
  description = "CI Stack for custom module: ${each.value}"
  
  vcs_repo {
    identifier      = "amiasea/.github"
    branch          = "main"
    
    github_app_installation_id = data.tfe_github_app_installation.amiasea_vcs.id
  }

  # --- PATCH WORKAROUND ---
  # Replace this when the tfe provider supports the working_directory attribute for stacks and remove the TFE PAT token
  # https://github.com/hashicorp/terraform-provider-tfe/issues/2027
  provisioner "local-exec" {

    command = <<EOT
      curl \
        --request PATCH \
        --header "Authorization: Bearer ${var.tfe_pat}" \
        --header "Content-Type: application/vnd.api+json" \
        --data '{
          "data": {
            "id": "${self.id}",
            "type": "stacks",
            "attributes": {
              "vcs-repo": {
                "identifier": "amiasea/.github",
                "branch": "main",
                "github-app-installation-id": "${data.tfe_github_app_installation.amiasea_vcs.id}",
                "working-directory": "terraform/stacks/${each.key}",
                "trigger-patterns": [
                  "terraform/stacks/${each.key}/**/*"
                ]
              }
            }
          }
        }' \
        https://app.terraform.io/api/v2/stacks/${self.id}
    EOT
  }
}