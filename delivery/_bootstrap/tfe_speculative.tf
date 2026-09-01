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

resource "tfe_variable" "speculative_azure_tenant_id" {
  key             = "speculative_azure_tenant_id"
  value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
  category        = "terraform"
  variable_set_id = tfe_variable_set.speculative.id
}

resource "tfe_variable" "speculative_azure_subscription_id" {
  key             = "speculative_azure_subscription_id"
  value           = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"
  category        = "terraform"
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
  value           = "55a110cd-185b-4d34-a0c5-e28e59167a31"
  category        = "env"
  variable_set_id = tfe_variable_set.speculative.id
}