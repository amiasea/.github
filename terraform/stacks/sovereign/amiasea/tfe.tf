resource "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name = "amiasea"
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = "amiasea"
}

######################################
######################################

resource "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

resource "tfe_variable_set" "amiasea_stack_oidc" {
  name         = "amiasea-stack-oidc"
  description  = "Azure OIDC coordinates for Amiasea Stack workloads."
  organization = "amiasea"
  global       = false
}

resource "tfe_project_variable_set" "stack_oidc" {
  variable_set_id = tfe_variable_set.amiasea_stack_oidc.id
  project_id      = data.tfe_project.amiasea_project.id
}

resource "tfe_variable" "stack_oidc_azure_client_id" {
  key             = "azure_client_id"
  value           = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_stack_oidc.id
}

resource "tfe_variable" "stack_oidc_azure_tenant_id" {
  key             = "azure_tenant_id"
  value           = var.azure_tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_stack_oidc.id
}

resource "tfe_variable" "stack_oidc_azure_subscription_id" {
  key             = "azure_subscription_id"
  value           = var.azure_subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_stack_oidc.id
}

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
  organization = "amiasea"
  global       = false
}

resource "tfe_project_variable_set" "amiasea_sovereign" {
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  project_id      = data.tfe_project.amiasea_project.id
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

data "http" "sovereign_stack_vcs_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    tfe_stack.sovereign_stack.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.tfe_org_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    tfe_stack.sovereign_stack,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for sovereign Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}