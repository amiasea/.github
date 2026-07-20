resource "github_repository" "iac_module_catalog" {
  name = "iac-module-catalog"
}

resource "github_repository" "iac_stack_catalog" {
  name = "iac-stack-catalog"
}

resource "github_organization_ruleset" "global_issue_template_lock" {
  name        = "global-issue-template-lock"
  target      = "push"
  enforcement = "active"

  # Target only application repositories that should inherit org defaults
  conditions {
    repository_name {
      include = [
        "*"
      ]
      exclude = [
        ".github"
      ]
    }
  }

  rules {
    file_path_restriction {
      restricted_file_paths = [
        ".github/ISSUE_TEMPLATE/**/*"
      ]
    }
  }

  bypass_actors {
    actor_id    = "2670685"
    actor_type  = "Integration"
    bypass_mode = "always"
  }
}

resource "github_organization_ruleset" "global_provider_repo_lock" {
  name        = "global-provider-repo-lock"
  target      = "push"
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

resource "github_actions_organization_oidc_subject_claim_customization_template" "main" {
  # This tells GitHub to pack these specific pieces of data into the 'sub' claim
  include_claim_keys = [
    "repo",
    "job_workflow_ref",
    "context"
  ]
}

resource "github_actions_repository_oidc_subject_claim_customization_template" "sovereign" {
  repository  = ".github"
  use_default = false

  # Use the Organization's template, 
  # Leave include_claim_keys empty to inherit it.
  include_claim_keys = [
    "job_workflow_ref",
  ]
}





# Enable this if .github goes private
# resource "github_actions_repository_access_level" "central_hub_sharing" {
#   repository   = ".github"
#   access_level = "organization"
# }

# resource "github_organization_settings" "org_bootstrap" {
#   billing_email = var.billing_email
  
#   # Prevents standard developers from creating repos via the UI/CLI
#   members_can_create_repositories        = false
#   members_can_create_public_repositories = false
#   members_can_create_private_repositories = false
#   members_can_create_internal_repositories = false
# }

# resource "github_organization_security_configuration" "disable_auto_scans" {
#   name        = "custom-lean-pipeline"
#   description = "Disables default security scanning to prioritize minted workflows"

#   # Turns off the automated background engine
#   code_scanning_default_setup = "disabled"

#   # Optional: Keep secret scanning active but skip full code analysis
#   secret_scanning             = "enabled"
#   secret_scanning_push_protection = "enabled"
# }