resource "tfe_project" "amiasea" {
  name = "Amiasea Engineering Delivery Model"
}

resource "tfe_variable_set" "amiasea_set" {
  name             = "Amiasea Varset"
  organization     = var.client_tfe_organization
  parent_project_id = tfe_project.amiasea.id
  global            = false
}

resource "tfe_variable" "tfe_token" {
  key             = "tfe-token"
  value           = var.client_tfe_token
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = var.client_github_organization
}