
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

resource "github_organization_security_configuration" "disable_auto_scans" {
  name        = "custom-lean-pipeline"
  description = "Disables default security scanning to prioritize minted workflows"

  # Turns off the automated background engine
  code_scanning_default_setup = "disabled"
  
  # Optional: Keep secret scanning active but skip full code analysis
  secret_scanning             = "enabled"
  secret_scanning_push_protection = "enabled"
}

resource "github_organization_ruleset" "global_provider_repo_lock" {
  name        = "global-provider-repo-lock"
  target      = "branch"
  enforcement = "active"

  # 1. Target only your provider repositories based on your naming pattern
  conditions {
    repository_name {
      include = ["terraform-provider-*"] # Targets all current and future provider repos
      exclude = []
    }
  }

  # 2. Set the global path restrictions
  rules {
    file_path_restriction {
      restricted_file_paths = [
        ".github/workflows/**/*",
        ".goreleaser.yaml"
      ]
    }
  }

  bypass_actors {
    actor_id    = "2670685"
    actor_type  = "Integration"
    bypass_mode = "always"
  }
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
