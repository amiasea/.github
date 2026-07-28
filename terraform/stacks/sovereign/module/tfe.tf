data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = "amiasea"
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

resource "tfe_stack" "edm_installation_registry" {
  depends_on = [
    azurerm_federated_identity_credential.edm_installation_registry_plan,
    azurerm_federated_identity_credential.edm_installation_registry_apply,
    tfe_variable.stack_oidc_azure_client_id,
    tfe_variable.stack_oidc_azure_tenant_id,
    tfe_variable.stack_oidc_azure_subscription_id,
  ]

  name       = "edm_installation_registry"
  project_id = data.tfe_project.amiasea_project.id

  working_directory = "terraform/stacks/edm_installation_registry"

  trigger_patterns = [
    "terraform/stacks/edm_installation_registry/**/*"
  ]

  vcs_repo {
    identifier                 = "amiasea/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }
}

data "http" "edm_installation_registry_stack_vcs_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    tfe_stack.edm_installation_registry.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.tfe_org_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    tfe_stack.edm_installation_registry,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for edm_installation_registry Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}