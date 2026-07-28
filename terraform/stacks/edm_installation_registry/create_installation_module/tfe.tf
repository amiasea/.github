resource "tfe_project" "amiasea" {
  organization = var.client_tfe_organization
  name = "Amiasea Engineering Delivery Model"
}

resource "tfe_variable_set" "amiasea_set" {
  name             = "amiasea"
  organization     = var.client_tfe_organization
  parent_project_id = tfe_project.amiasea.id
  global            = false
}

resource "tfe_variable" "tfe_token" {
  key             = "tfe_token"
  value           = var.client_tfe_token
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

resource "tfe_variable" "tfe_organization" {
  key             = "tfe_organization"
  value           = var.client_tfe_organization
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = var.client_github_organization
}
