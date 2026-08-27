# resource "tfe_project" "institutive" {
#   organization = var.organization_name
#   name         = "institutive"
# }

# resource "tfe_variable_set" "institutive" {
#   name        = "institutive"
#   description = "Institutive environment context."
# }

# resource "tfe_project_variable_set" "institutive" {
#   variable_set_id = tfe_variable_set.institutive.id
#   project_id      = tfe_project.institutive.id
# }

# resource "tfe_variable" "azure_tenant_id" {
#   key             = "azure_tenant_id"
#   value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
#   category        = "env"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "azure_subscription_id" {
#   key             = "azure_subscription_id"
#   value           = "da348b35-29b6-4906-85ec-4a097aa5fe04"
#   category        = "env"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "tfc_azure_provider_auth" {
#   key             = "TFC_AZURE_PROVIDER_AUTH"
#   value           = "true"
#   category        = "env"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "tfc_azure_run_client_id" {
#   key             = "TFC_AZURE_RUN_CLIENT_ID"
#   value           = "241cd7c9-cc16-416e-91c0-df11b35846fa"
#   category        = "env"
#   variable_set_id = tfe_variable_set.institutive.id
# }