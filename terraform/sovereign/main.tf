data "azurerm_client_config" "current" {}

data "github_repository" "repo" {
  full_name = "amiasea/.github"
}

resource "azurerm_resource_group" "rg_amiasea" {
  name     = var.resource_group_name
  location = var.location
  tags = { Plane = "Sovereign" }
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
  resource_group_name = azurerm_resource_group.rg_amiasea.name
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

resource "azuread_directory_role_assignment" "write_uami_app_admin" {
  role_id             = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" # Application Administrator
  principal_object_id = azurerm_user_assigned_identity.write.principal_id
}

# ---------------------------------------------------------
# Write sovereign facts into GitHub Variables
# These are NOT secrets — they are stable infra facts.
# ---------------------------------------------------------

resource "github_actions_organization_variable" "tenant_id" {
  variable_name           = "TENANT_ID"
  value                   = data.azurerm_client_config.current.tenant_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "subscription_id" {
  variable_name           = "SUBSCRIPTION_ID"
  value                   = data.azurerm_client_config.current.subscription_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "uami_read_id" {
  variable_name           = "UAMI_READ_ID"
  value                   = azurerm_user_assigned_identity.read.id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "uami_read_client_id" {
  variable_name           = "UAMI_READ_CLIENT_ID"
  value                   = azurerm_user_assigned_identity.read.client_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "uami_read_principal_id" {
  variable_name           = "UAMI_READ_PRINCIPAL_ID"
  value                   = azurerm_user_assigned_identity.read.principal_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "uami_write_client_id" {
  variable_name           = "UAMI_WRITE_CLIENT_ID"
  value                   = azurerm_user_assigned_identity.write.client_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "uami_write_principal_id" {
  variable_name           = "UAMI_WRITE_PRINCIPAL_ID"
  value                   = azurerm_user_assigned_identity.write.principal_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "resource_group_name" {
  variable_name           = "RESOURCE_GROUP_NAME"
  value                   = var.resource_group_name
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "location" {
  variable_name           = "LOCATION"
  value                   = var.location
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "key_vault_name" {
  variable_name           = "KEY_VAULT_NAME"
  value                   = var.key_vault_name
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "aviator_gh_app_id" {
  variable_name           = "AVIATOR_GH_APP_ID"
  value                   = var.aviator_gh_app_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

resource "github_actions_organization_variable" "aviator_private_key_name" {
  variable_name           = "AVIATOR_PRIVATE_KEY_NAME"
  value                   = var.aviator_private_key_name
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}