data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = "amiasea"
}

data "http" "edm_installation_registry" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

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
          "service-provider"           = "github"
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