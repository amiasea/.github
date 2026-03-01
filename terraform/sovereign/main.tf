data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_amiasea" {
  name     = var.resource_group_name
  location = var.location
  tags = { Plane = "Sovereign" }
}

resource "hcp_project" "sovereign_project" {
  name        = var.hcp_project_name
  description = "Managed by GitHub OIDC automation"
}

# # 1. Locate the existing Owners team
# data "tfe_team" "owners" {
#   name         = "owners"
#   organization = var.tfe_organization
# }

# # This token inherits full administrative rights over the entire Org
# resource "tfe_team_token" "sovereign_token" {
#   team_id = data.tfe_team.owners.id
# }

# 3. Create the HCP Service Principal for Cloud Identity
resource "hcp_service_principal" "sovereign_sp" {
  name = "amiasea-sovereign"

  parent = hcp_project.sovereign_project.resource_name
}

resource "hcp_service_principal_key" "sovereign_key" {
  service_principal = hcp_service_principal.sovereign_sp.resource_name
}

resource "hcp_project_iam_binding" "sovereign_admin" {
  project_id   = hcp_project.sovereign_project.resource_id
  principal_id = hcp_service_principal.sovereign_sp.resource_id
  role         = "roles/admin"
}

resource "hcp_iam_workload_identity_provider" "wip" {
  name              = "github"
  service_principal = hcp_service_principal.sovereign_sp.resource_name
  description       = "Allow amiasea/.github repo deploy workflow to access amiasea-sovereign service principal"

  oidc = {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  conditional_access = "jwt_claims.repository == `amiasea/.github` and jwt_claims.ref == `refs/heads/main`"
}

# --- SOVEREIGN IDENTITIES (UAMI) ---
resource "azurerm_user_assigned_identity" "write" {
  name                = "Amiasea-Write"
  resource_group_name = azurerm_resource_group.rg_amiasea.name
  location            = var.location
  tags = { Plane = "Authority" }
}

resource "azurerm_user_assigned_identity" "read" {
  name                = "Amiasea-Read"
  resource_group_name = azurerm_resource_group.rg_amiasea.name
  location            = var.location
  tags = { Plane = "Authority" }
}

# --- FEDERATED CREDENTIAL (GitHub → UAMI) ---
resource "azurerm_federated_identity_credential" "github" {
  name                = "amiasea-github"
  parent_id           = azurerm_user_assigned_identity.write.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:amiasea/.github:ref:refs/heads/main"
}

# --- SUBSCRIPTION OWNER (ARM POWER) ---
resource "azurerm_role_assignment" "owner" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.write.principal_id
}