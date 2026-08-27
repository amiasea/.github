# resource "tfe_project" "governance" {
#   organization = var.organization_name
#   name         = "governance"
# }

# resource "tfe_variable_set" "governance" {
#   name        = "governance"
#   description = "Governance environment context."
# }

# resource "tfe_project_variable_set" "governance" {
#   variable_set_id = tfe_variable_set.governance.id
#   project_id      = tfe_project.governance.id
# }

# resource "tfe_variable" "amiasea_github_app_id" {
#   key             = "GITHUB_APP_ID"
#   value           = "2670685"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.environment.id
# }

# resource "tfe_variable" "amiasea_github_app_installation_id" {
#   key             = "GITHUB_APP_INSTALLATION_ID"
#   value           = "105130264"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.environment.id
# }