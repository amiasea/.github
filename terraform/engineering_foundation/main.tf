data "tfe_organization" "amiasea_tfe_org" {
  name = "amiasea"
}

data "tfe_workspace" "accession_workspace" {
  name         = "accession"
  organization = data.tfe_organization.amiasea_tfe_org.name
}

data "tfe_workspace" "engineering_foundation" {
  name         = "engineering_foundation"
  organization = data.tfe_organization.amiasea_tfe_org.name
}

resource "tfe_run_trigger" "run_trigger" {
  workspace_id  = tfe_workspace.engineering_foundation.id
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
