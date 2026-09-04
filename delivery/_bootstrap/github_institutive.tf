locals {
  institutive_artifacts_protected_branches = toset([
    "development",
    "main",
  ])
}

data "github_repository" "institutive_artifacts" {
  full_name = "${var.organization_name}/institutive-artifacts"
}

resource "github_branch_protection" "institutive_artifacts" {
  for_each = local.institutive_artifacts_protected_branches

  repository_id = data.github_repository.institutive_artifacts.node_id
  pattern       = each.value

  enforce_admins                  = true
  allows_force_pushes             = false
  allows_deletions                = false
  require_conversation_resolution = true

  required_pull_request_reviews {
    required_approving_review_count = 0
    dismiss_stale_reviews           = true
  }

  required_status_checks {
    strict = false

    contexts = [
      "Continuous Integration / API Tests",
      "Continuous Integration / Data Migrations Tests",
      "Continuous Integration / Webhook Adapter Tests",
      "Continuous Integration / Worker Tests",
    ]
  }
}
