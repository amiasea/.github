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

# resource "tfe_variable" "institutive_azure_tenant_id" {
#   key             = "institutive_azure_tenant_id"
#   value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "institutive_azure_subscription_id" {
#   key             = "institutive_azure_subscription_id"
#   value           = "da348b35-29b6-4906-85ec-4a097aa5fe04"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "institutive_azure_client_id" {
#   key             = "institutive_azure_client_id"
#   value           = "55a110cd-185b-4d34-a0c5-e28e59167a31"
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "institutive_github_app_id" {
#   key             = "institutive_github_app_id"
#   value           = var.github_app_id
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_variable" "institutive_github_app_installation_id" {
#   key             = "institutive_github_app_installation_id"
#   value           = var.github_app_installation_id
#   category        = "terraform"
#   variable_set_id = tfe_variable_set.institutive.id
# }

# resource "tfe_stack" "institutive" {
#   name                = "institutive"
#   description         = "Stack for managing the Amiasea Institutive delivery mechanics"
#   project_id          = tfe_project.institutive.id
#   speculative_enabled = true
#   trigger_patterns    = ["**/*"]

#   vcs_repo {
#     identifier                 = "${var.organization_name}/institutive-artifacts-delivery"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }
