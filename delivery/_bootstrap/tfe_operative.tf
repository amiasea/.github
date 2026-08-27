# resource "tfe_project" "operative" {
#   organization = var.organization_name
#   name         = "operative"
# }

# resource "tfe_variable_set" "operative" {
#   name        = "operative"
#   description = "Operative environment context."
# }

# resource "tfe_project_variable_set" "operative" {
#   variable_set_id = tfe_variable_set.operative.id
#   project_id      = tfe_project.operative.id
# }
# resource "tfe_variable" "azure_tenant_id" {
#   key             = "azure_tenant_id"
#   value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.operative.id
# }

# resource "tfe_variable" "azure_subscription_id" {
#   key             = "azure_subscription_id"
#   value           = "ad9cd6518-e401-4072-a410-a6a67e9b15f6"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.operative.id
# }

# resource "tfe_variable" "azure_client_id" {
#   key             = "azure_client_id"
#   value           = "241cd7c9-cc16-416e-91c0-df11b35846fa"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.operative.id
# }