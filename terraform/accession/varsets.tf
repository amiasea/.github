# Azure

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

resource "tfe_project_settings" "amiasea_project_settings" {
  project_id             = data.tfe_project.amiasea_project.id
  default_execution_mode = "remote"
}

data "tfe_workspace" "accession" {
  organization = "amiasea"
  name         = "accession"
}

resource "tfe_variable_set" "authority" {
  name        = "authority"
  description = "Authority context for amiasea execution contexts."
  workspace_ids = [
    data.tfe_workspace.accession.id,
  ]
}

resource "tfe_project_variable_set" "amiasea" {
  project_id      = data.tfe_project.amiasea_project.id
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key             = "TFC_AZURE_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "tfc_azure_workload_identity_audience" {
  key             = "TFC_AZURE_WORKLOAD_IDENTITY_AUDIENCE"
  value           = "api://AzureADTokenExchange"
  category        = "env"
  variable_set_id = tfe_variable_set.authority.id
}
 
resource "tfe_variable" "tfc_azure_run_client_id" {
  sensitive       = true
  key             = "TFC_AZURE_RUN_CLIENT_ID"
  value           = azuread_application.amiasea_authority.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.authority.id
}

# AWS

# GCP
