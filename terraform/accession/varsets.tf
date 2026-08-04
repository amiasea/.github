# Azure

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

resource "tfe_variable_set" "authority" {
  name        = "authority"
  description = "Authority context for amiasea execution contexts."
}

resource "tfe_project_variable_set" "amiasea" {
  project_id      = data.tfe_project.amiasea_project.id
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "authority_azure_tenant_id" {
  key             = "authority_azure_tenant_id"
  value           = var.authority_azure_tenant_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "authority_azure_client_id" {
  key             = "authority_azure_client_id"
  value           = azuread_application.amiasea_authority.client_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "sovereign_azure_subscription_id" {
  key             = "sovereign_azure_subscription_id"
  value           = var.sovereign_azure_subscription_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "sovereign_azure_key_vault_id" {
  key             = "sovereign_azure_key_vault_id"
  value           = azurerm_key_vault.sovereign_kv.id
  category        = "terraform"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "sovereign_azure_resource_group_name" {
  key             = "sovereign_azure_resource_group_name"
  value           = azurerm_resource_group.amiasea_sovereign_rg.name
  category        = "terraform"
  variable_set_id = tfe_variable_set.authority.id
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key             = "TFC_AZURE_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.authority.id
  # workspace_id    = tfe_workspace.default.id
}
 
resource "tfe_variable" "tfc_azure_run_client_id" {
  sensitive       = true
  key             = "TFC_AZURE_RUN_CLIENT_ID"
  value           = azuread_application.amiasea_authority.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.authority.id
  # workspace_id    = tfe_workspace.default.id
}

# AWS

# GCP
