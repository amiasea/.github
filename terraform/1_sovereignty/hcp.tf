data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}

resource "tfe_workspace" "workspace_dev" {
  name         = "amiasea-dev"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

resource "tfe_workspace" "workspace_prod" {
  name         = "amiasea-prod"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

# resource "tfe_stack" "regional_stack" {
#   name       = "asia-vnet-stack"
#   project_id = tfe_project.new_region.id
#   # ... VCS config ...
# }