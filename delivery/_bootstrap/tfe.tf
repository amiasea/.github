data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

# AWS

# GCP

# WORKSPACES

# resource "tfe_workspace" "institutive" {
#   name         = "institutive"
#   description  = "Workspace for managing the Institutive delivery mechanics"
#   organization = var.organization_name
#   project_id   = tfe_project.delivery.id

#   working_directory     = "delivery/institutive"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }

# resource "tfe_workspace_settings" "institutive" {
#   workspace_id   = tfe_workspace.institutive.id
#   auto_apply     = true
#   execution_mode = "remote"

#   depends_on = [
#     tfe_workspace.institutive
#   ]
# }