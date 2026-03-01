# -------------------------------------------------------------------
# AMIASEA ORGANIZATION
# -------------------------------------------------------------------
resource "tfe_organization_default_settings" "org_defaults" {
  organization = var.tfe_organization

  default_execution_mode = "local"
}

resource "tfe_project" "amiasea_project" {
  name         = "amiasea"
  organization = var.tfe_organization
}

# -------------------------------------------------------------------
# SOVEREIGN WORKSPACE (Sovereign plane)
# -------------------------------------------------------------------
resource "tfe_workspace" "sovereign" {
  name         = "amiasea-sovereign"
  organization = var.tfe_organization
  project_id   = tfe_project.amiasea_project.id
}

resource "tfe_workspace_settings" "sovereign_settings" {
  workspace_id   = tfe_workspace.sovereign.id
  execution_mode = "local"
}

# -------------------------------------------------------------------
# AUTHORITY WORKSPACE (ARM plane)
# -------------------------------------------------------------------
resource "tfe_workspace" "authority" {
  name         = "amiasea-authority"
  organization = var.tfe_organization
  project_id   = tfe_project.amiasea_project.id
}

resource "tfe_workspace_settings" "authority_settings" {
  workspace_id   = tfe_workspace.authority.id
  execution_mode = "local"
}

# -------------------------------------------------------------------
# IDENTITY WORKSPACE (Graph plane)
# -------------------------------------------------------------------
resource "tfe_workspace" "identity" {
  name         = "amiasea-identity"
  organization = var.tfe_organization
  project_id   = tfe_project.amiasea_project.id
}

resource "tfe_workspace_settings" "identity_settings" {
  workspace_id   = tfe_workspace.identity.id
  execution_mode = "local"
}

# -------------------------------------------------------------------
# PLATFORM WORKSPACE (Platform plane)
# -------------------------------------------------------------------
resource "tfe_workspace" "platform" {
  name         = "amiasea-platform"
  organization = var.tfe_organization
  project_id   = tfe_project.amiasea_project.id
}

resource "tfe_workspace_settings" "platform_settings" {
  workspace_id   = tfe_workspace.platform.id
  execution_mode = "local"
}