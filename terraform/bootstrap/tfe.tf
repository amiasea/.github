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

data "http" "edm_installation_registry" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

  # depends_on = [ tfe_registry_module.whisper_genie ]

  request_headers = {
    Authorization = "Bearer ${var.tfe_org_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"

      attributes = {
        name = "edm_installation_registry"

        "vcs-repo" = {
          identifier                   = "amiasea/.github"
          branch                       = "main"
          "github-app-installation-id" = data.tfe_github_app_installation.tfe_cloud_app.id
        }

        "working-directory" = "terraform/stacks/edm_installation_registry"

        "trigger-patterns" = [
          "terraform/stacks/edm_installation_registry/**/*"
        ]
      }

      relationships = {
        project = {
          data = {
            type = "projects"
            id   = data.tfe_project.amiasea_project.id
          }
        }
      }
    }
  })
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
  key             = "AZURE_CLIENT_ID"
  value           = azuread_application.amiasea_sovereign.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_tenant_id" {
  key             = "AZURE_TENANT_ID"
  value           = var.tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_subscription_id" {
  key             = "AZURE_SUBSCRIPTION_ID"
  value           = var.subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}
