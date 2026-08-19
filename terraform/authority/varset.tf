# Azure

data "azurerm_client_config" "current" {}

data "tfe_variable_set" "sovereign" {
  name         = "sovereign"
  organization = "amiasea"
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key             = "TFC_AZURE_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_variable" "tfc_azure_workload_identity_audience" {
  key             = "TFC_AZURE_WORKLOAD_IDENTITY_AUDIENCE"
  value           = "api://AzureADTokenExchange"
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_variable" "arm_tenant_id" {
  sensitive       = true
  key             = "ARM_TENANT_ID"
  value           = data.azurerm_client_config.current.tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_variable" "tfc_azure_run_client_id" {
  sensitive       = true
  key             = "TFC_AZURE_RUN_CLIENT_ID"
  value           = azuread_application.amiasea_authority.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

# AWS

# GCP
