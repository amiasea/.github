# resource "tfe_project" "prospective" {
#   organization = var.organization_name
#   name         = "prospective"
# }

# resource "tfe_variable_set" "prospective" {
#   name        = "prospective"
#   description = "Prospective environment context."
# }

# resource "tfe_project_variable_set" "prospective" {
#   variable_set_id = tfe_variable_set.prospective.id
#   project_id      = tfe_project.prospective.id
# }

# resource "tfe_variable" "azure_tenant_id" {
#   key             = "azure_tenant_id"
#   value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.prospective.id
# }

# resource "tfe_variable" "azure_subscription_id" {
#   key             = "azure_subscription_id"
#   value           = "a1a3e3e6-6a34-455d-b220-f6df7790f905"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.prospective.id
# }

# resource "tfe_variable" "azure_client_id" {
#   key             = "azure_client_id"
#   value           = "241cd7c9-cc16-416e-91c0-df11b35846fa"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.prospective.id
# }