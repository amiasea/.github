resource "tfe_project" "imperative" {
  organization = var.organization_name
  name         = "imperative"
}

resource "tfe_variable_set" "imperative" {
  name        = "imperative"
  description = "Imperative environment context."
}

resource "tfe_project_variable_set" "imperative" {
  variable_set_id = tfe_variable_set.imperative.id
  project_id      = tfe_project.imperative.id
}

resource "tfe_variable" "imperative_azure_tenant_id" {
  key             = "imperative_azure_tenant_id"
  value           = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
  category        = "terraform"
  variable_set_id = tfe_variable_set.imperative.id
}

resource "tfe_variable" "imperative_azure_subscription_id" {
  key             = "imperative_azure_subscription_id"
  value           = "c7450111-a44d-47e1-86a4-dce7ad5769bf"
  category        = "terraform"
  variable_set_id = tfe_variable_set.imperative.id
}

resource "tfe_variable" "imperative_azure_client_id" {
  key             = "imperative_azure_client_id"
  value           = "55a110cd-185b-4d34-a0c5-e28e59167a31"
  category        = "terraform"
  variable_set_id = tfe_variable_set.imperative.id
}

resource "tfe_variable" "imperative_github_app_id" {
  key             = "imperative_github_app_id"
  value           = var.github_app_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.imperative.id
}

resource "tfe_variable" "imperative_github_app_installation_id" {
  key             = "imperative_github_app_installation_id"
  value           = var.github_app_installation_id
  category        = "terraform"
  variable_set_id = tfe_variable_set.imperative.id
}

resource "tfe_stack" "imperative" {
  name                = "imperative"
  description         = "Stack for managing the Amiasea imperative delivery mechanics"
  project_id          = tfe_project.imperative.id
  speculative_enabled = true
  trigger_patterns    = ["**/*"]

  vcs_repo {
    identifier                 = "${var.organization_name}/imperative"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}
