data "tfe_github_app_installation" "tfe_cloud_app" {
  name = "amiasea"
}

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

resource "tfe_registry_module" "whisper_genie" {
  organization    = "amiasea"
  name            = "whisper_genie"
  module_provider = "amiasea"
  registry_name   = "private"

  vcs_repo {
    display_identifier         = "amiasea/.github"
    identifier                 = "amiasea/.github"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id

    tags             = true
    source_directory = "terraform/modules/whisper_genie"
    tag_prefix       = "whisper_genie-v"
  }
}

resource "tfe_variable_set" "amiasea_sovereign" {
  name         = "amiasea-sovereign"
  description  = "Azure OIDC coordinates for the Amiasea sovereign stack."
  organization = var.organization_name
  global       = false
}

resource "tfe_project_variable_set" "amiasea_sovereign" {
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  project_id      = data.tfe_project.amiasea_project.id
}

resource "tfe_variable" "sovereign_azure_client_id" {
  key             = "sovereign_azure_client_id"
  value           = azuread_application.amiasea_sovereign.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_tenant_id" {
  key             = "sovereign_azure_tenant_id"
  value           = var.tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_subscription_id" {
  key             = "sovereign_azure_subscription_id"
  value           = var.subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_stack" "sovereign_stack" {
  name       = "sovereign"
  project_id = data.tfe_project.amiasea_project.id

  working_directory = "terraform/stacks/sovereign"

  trigger_patterns = [
    "terraform/stacks/sovereign/**/*"
  ]

  vcs_repo {
    identifier                 = "amiasea/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }
}