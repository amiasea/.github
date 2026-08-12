# Azure

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

resource "tfe_variable_set" "amiasea_execution_context" {
  name        = "amiasea-execution-context"
  description = "Shared execution coordinates for Amiasea Terraform workspaces."
}

resource "tfe_project_variable_set" "stack_oidc" {
  project_id      = data.tfe_project.amiasea_project.id
  variable_set_id = tfe_variable_set.amiasea_execution_context.id
}

resource "tfe_variable" "stack_oidc_azure_client_id" {
  key             = "azure_client_id"
  value           = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.client_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_execution_context.id
}

resource "tfe_variable" "stack_oidc_azure_tenant_id" {
  key             = "azure_tenant_id"
  value           = data.azurerm_client_config.current.tenant_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_execution_context.id
}

resource "tfe_variable" "stack_oidc_azure_subscription_id" {
  key             = "azure_subscription_id"
  value           = data.azurerm_client_config.current.subscription_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_execution_context.id
}

# AWS

# GCP