data "github_repository" "repo" {
  full_name = "amiasea/.github"
}

resource "github_actions_organization_variable" "sql_admins_group_id" {
  variable_name           = "SQL_ADMINS_GROUP_ID"
  value                   = azuread_group.sql_admins.object_id
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

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

resource "github_actions_organization_variable" "delegated_permissions_client_id" {
  # Updated naming to be accurate (it's an App ID now, not a UAMI)
  variable_name           = "AZURE_CLIENT_ID" 
  
  # Point to the App Registration's client_id
  value                   = azurerm_user_assigned_identity.delegated_permissions.client_id
  
  visibility              = "selected"
  selected_repository_ids = [data.github_repository.repo.repo_id]
}

# resource "github_actions_organization_variable" "aviator_gh_app_id" {
#   variable_name           = "AMIASEA_GH_APP_ID"
#   value                   = "2670685"
#   visibility              = "selected"
#   selected_repository_ids = [data.github_repository.repo.repo_id]
# }

# resource "github_actions_organization_variable" "amiasea_private_key_versionless_id" {
#   variable_name           = "AMIASEA_PRIVATE_KEY_VERSIONLESS_ID"
#   value                   = azurerm_key_vault_secret.amiasea_github_private_key.versionless_id
#   visibility              = "selected"
#   selected_repository_ids = [data.github_repository.repo.repo_id]
# }

# resource "github_actions_organization_variable" "tf_token_versionless_id" {
#   variable_name           = "TF_TOKEN_VERSIONLESS_ID"
#   value                   = azurerm_key_vault_secret.tf_token.versionless_id
#   visibility              = "selected"
#   selected_repository_ids = [data.github_repository.repo.repo_id]
# }

# resource "github_actions_organization_variable" "ghcr_pat_versionless_id" {
#   variable_name           = "GHCR_PAT_VERSIONLESS_ID"
#   value                   = azurerm_key_vault_secret.ghcr_pat.versionless_id
#   visibility              = "selected"
#   selected_repository_ids = [data.github_repository.repo.repo_id]
# }