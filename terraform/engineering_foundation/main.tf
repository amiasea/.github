data "tfe_organization" "amiasea_tfe_org" {
  name = "amiasea"
}

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

data "tfe_github_app_installation" "gha_installation" {
  name = "amiasea"
}

data "tfe_workspace" "accession_workspace" {
  name         = "accession"
  organization = data.tfe_organization.amiasea_tfe_org.name
}

resource "tfe_workspace" "amiasea_workspace" {
  name         = "engineering_foundation"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea_project.id

  working_directory = "terraform/engineering_foundation"
  trigger_patterns  = ["terraform/engineering_foundation/**/*"]

  vcs_repo {
    identifier                 = "amiasea/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "amiasea_workspace_settings" {
  workspace_id   = tfe_workspace.amiasea_workspace.id
  execution_mode = "remote"
}

resource "tfe_run_trigger" "run_trigger" {
  workspace_id  = tfe_workspace.amiasea_workspace.id
  sourceable_id = data.tfe_workspace.accession_workspace.id
}

ephemeral "azurerm_key_vault_secret" "amiasea_tfe_org_token" {
  name         = "amiasea-tfe-org-token"
  key_vault_id = var.sovereign_azure_key_vault_id
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name         = "amiasea-github-app-private-key"
  key_vault_id = var.sovereign_azure_key_vault_id
}
