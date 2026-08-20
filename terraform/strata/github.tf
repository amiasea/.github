data "github_repository" "strata" {
  name      = "strata"
}

data "github_branch" "strata_main" {
  repository = data.github_repository.strata.name
  branch = "main"
}

resource "github_branch" "strata_development" {
  repository    = data.github_repository.strata.name
  source_branch = data.github_branch.strata_main.branch
  branch        = "development"
}

resource "github_branch_default" "default" {
  repository = data.github_repository.strata.name
  branch     = data.github_branch.strata_main.branch
}

resource "github_branch_protection_v3" "main_branch_protection" {
  repository     = data.github_repository.strata.name
  branch         = data.github_branch.strata_main.branch

  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  enforce_admins = true

  required_status_checks {
    strict = false
    checks = [
    ]
  }

  restrictions {
    users = []
    teams = []
    apps  = []
  }
}

resource "github_branch_protection_v3" "development_branch_protection" {
  repository = data.github_repository.strata.name
  branch     = github_branch.strata_development.branch

  required_pull_request_reviews {
    required_approving_review_count = 1

    dismiss_stale_reviews = true
  }

  enforce_admins = true

  required_status_checks {
    strict = true

    checks = [
      "ci/speculative-tests"
    ]
  }

  restrictions {
    users = []
    teams = []
    apps  = []
  }
}