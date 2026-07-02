
# Enable this if .github goes private
# resource "github_actions_repository_access_level" "central_hub_sharing" {
#   repository   = ".github"
#   access_level = "organization"
# }

resource github_repository_file "central_hub_workflow" {
  repository          = ".github"
  branch              = "main"
  file                = ".github/workflows/test.yml"
  commit_message      = "Managed by Terraform"
  overwrite_on_create = true

  content = file("${path.module}/test.yml")
}

resource "github_organization_settings" "org_bootstrap" {
  billing_email = var.billing_email
  
  # Prevents standard developers from creating repos via the UI/CLI
  members_can_create_repositories        = false
  members_can_create_public_repositories = false
  members_can_create_private_repositories = false
  members_can_create_internal_repositories = false
}


resource "github_actions_organization_variable" "arm_client_id" {
  variable_name = "AZURE_CLIENT_ID"
  value         = azuread_service_principal.delegated_permissions_sp.client_id
  visibility    = "all" # Options: "all", "private", or "selected"
}

resource "github_actions_organization_variable" "arm_tenant_id" {
  variable_name = "AZURE_TENANT_ID"
  value         = data.azurerm_client_config.current.tenant_id
  visibility    = "all"
}

resource "github_actions_organization_variable" "arm_subscription_id" {
  variable_name = "AZURE_SUBSCRIPTION_ID"
  value         = data.azurerm_client_config.current.subscription_id
  visibility    = "all"
}

resource "github_actions_organization_variable" "amiasea_gh_app_id" {
  variable_name = "AMIASEA_GH_APP_ID"
  value         = "2670685"
  visibility    = "all"
}

resource "github_actions_organization_variable" "amiasea_private_key_versionless_id" {
  variable_name = "AMIASEA_PRIVATE_KEY_VERSIONLESS_ID"
  value         = azurerm_key_vault_secret.amiasea_github_private_key.versionless_id
  visibility    = "all"
}

resource "github_actions_organization_variable" "tf_token_versionless_id" {
  variable_name = "TF_TOKEN_VERSIONLESS_ID"
  value         = azurerm_key_vault_secret.tf_token.versionless_id
  visibility    = "all"
}
