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

data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_github_app_installation" "gha_installation" {
  name = data.tfe_organization.organization.name
}

data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}