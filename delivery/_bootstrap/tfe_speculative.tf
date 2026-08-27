resource "tfe_project" "speculative" {
  organization = var.organization_name
  name         = "speculative"
}

resource "tfe_variable_set" "speculative" {
  name        = "speculative"
  description = "Speculative environment context."
}

resource "tfe_project_variable_set" "speculative" {
  variable_set_id = tfe_variable_set.speculative.id
  project_id      = tfe_project.speculative.id
}

resource "tfe_variable" "azure_tenant_id" {
  key             = "azure_tenant_id"
  value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
  category        = "env"
  variable_set_id = tfe_variable_set.speculative.id
}

resource "tfe_variable" "azure_subscription_id" {
  key             = "azure_subscription_id"
  value           = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"
  category        = "env"
  variable_set_id = tfe_variable_set.speculative.id
}

resource "tfe_variable" "tfc_azure_provider_auth" {
  key             = "TFC_AZURE_PROVIDER_AUTH"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.speculative.id
}

resource "tfe_variable" "tfc_azure_run_client_id" {
  key             = "TFC_AZURE_RUN_CLIENT_ID"
  value           = "241cd7c9-cc16-416e-91c0-df11b35846fa"
  category        = "env"
  variable_set_id = tfe_variable_set.speculative.id
}