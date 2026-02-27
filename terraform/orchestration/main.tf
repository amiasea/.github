# -------------------------------------------------------------------
# AMIASEA ORGANIZATION
# -------------------------------------------------------------------
resource "tfe_organization_default_settings" "org_defaults" {
  organization = var.tfe_organization

  default_execution_mode = "local"
}

# -------------------------------------------------------------------
# AUTHORITY WORKSPACE (ARM plane)
# -------------------------------------------------------------------
resource "tfe_workspace" "authority" {
  name         = "amiasea-authority"
  organization = var.tfe_organization
  project_id   = var.tfe_project_id
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
  project_id   = var.tfe_project_id
}

resource "tfe_workspace_settings" "identity_settings" {
  workspace_id   = tfe_workspace.identity.id
  execution_mode = "local"
}

# # -------------------------------------------------------------------
# # AUTHORITY WORKSPACE VARIABLES
# # -------------------------------------------------------------------
# resource "tfe_variable" "authority_resource_group_name" {
#   workspace_id = tfe_workspace.authority.id
#   key          = "resource_group_name"
#   value        = var.resource_group_name
#   category     = "terraform"
# }

# resource "tfe_variable" "authority_location" {
#   workspace_id = tfe_workspace.authority.id
#   key          = "location"
#   value        = var.location
#   category     = "terraform"
# }

# resource "tfe_variable" "authority_dockerhub_username" {
#   workspace_id = tfe_workspace.authority.id
#   key          = "dockerhub_username"
#   value        = var.dockerhub_username
#   category     = "terraform"
# }

# resource "tfe_variable" "authority_dockerhub_password" {
#   workspace_id = tfe_workspace.authority.id
#   key          = "dockerhub_password"
#   value        = var.dockerhub_password
#   category     = "terraform"
#   sensitive    = true
# }

# resource "tfe_variable" "authority_tenant_id" {
#   workspace_id = tfe_workspace.authority.id
#   key          = "tenant_id"
#   value        = var.tenant_id
#   category     = "terraform"
# }