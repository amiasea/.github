data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

resource "tfe_project" "foundation" {
  organization = var.organization_name
  name         = "foundation"
}

resource "tfe_project_settings" "foundation" {
  project_id             = tfe_project.foundation.id
  default_execution_mode = "remote"
}

resource "tfe_project" "promotion" {
  organization = var.organization_name
  name         = "promotion"
}

resource "tfe_project_settings" "promotion" {
  project_id             = tfe_project.promotion.id
  default_execution_mode = "remote"
}

resource "tfe_variable_set" "sovereign" {
  name        = "sovereign"
  description = "Sovereign context for institutive execution contexts."
  workspace_ids = [
    tfe_workspace.strata.id,
    tfe_workspace.kitting.id,
  ]
}

resource "tfe_project_variable_set" "sovereign_to_promotion" {
  project_id      = tfe_project.promotion.id
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_variable" "amiasea_github_app_id" {
  sensitive       = true
  key             = "GITHUB_APP_ID"
  value           = "2670685"
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_variable" "amiasea_github_app_installation_id" {
  sensitive       = true
  key             = "GITHUB_APP_INSTALLATION_ID"
  value           = "105130264"
  category        = "env"
  variable_set_id = tfe_variable_set.sovereign.id
}

resource "tfe_workspace" "authority" {
  name         = "authority"
  description  = "Workspace for managing the Authority context"
  organization = var.organization_name
  project_id   = tfe_project.foundation.id

  working_directory      = "terraform/authority"
  file_triggers_enabled  = true
  speculative_enabled    = false
  auto_apply_run_trigger = true

  depends_on = [
    tfe_workspace.strata,
    tfe_workspace.kitting,
  ]
}

resource "tfe_workspace_settings" "authority" {
  workspace_id   = tfe_workspace.authority.id
  execution_mode = "local"
  auto_apply     = true

  depends_on = [
    tfe_workspace.authority
  ]
}

resource "tfe_workspace" "strata" {
  name         = "strata"
  description  = "Workspace for managing the Strata delivery mechanics"
  organization = var.organization_name
  project_id   = tfe_project.foundation.id

  working_directory     = "terraform/strata"
  file_triggers_enabled = true
  speculative_enabled   = false

  vcs_repo {
    identifier                 = "${var.organization_name}/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "strata" {
  workspace_id   = tfe_workspace.strata.id
  auto_apply     = true
  execution_mode = "remote"

  depends_on = [
    tfe_workspace.strata
  ]
}

resource "tfe_workspace" "kitting" {
  name         = "kitting"
  description  = "Workspace for managing the Kitting repository"
  organization = var.organization_name
  project_id   = tfe_project.foundation.id

  working_directory     = "terraform/kitting"
  file_triggers_enabled = true
  speculative_enabled   = false

  vcs_repo {
    identifier                 = "${var.organization_name}/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "kitting" {
  workspace_id   = tfe_workspace.kitting.id
  auto_apply     = true
  execution_mode = "remote"

  depends_on = [
    tfe_workspace.kitting
  ]
}

resource "tfe_run_trigger" "strata_to_kitting" {
  sourceable_id = tfe_workspace.strata.id
  workspace_id  = tfe_workspace.kitting.id
}
