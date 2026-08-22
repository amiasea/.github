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

resource "github_repository_ruleset" "main" {
  name        = "main"
  repository  = data.github_repository.strata.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/main"]
      exclude = []
    }
  }

  rules {
    # Nobody pushes directly to main.
    update = true

    # Require all changes to arrive through a pull request.
    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review          = false
      require_last_push_approval         = false
      required_approving_review_count    = 1
      required_review_thread_resolution  = true
    }

    # Prevent merge commits.
    required_linear_history = true

    # Require signed commits.
    required_signatures = true
  }
}

resource "github_repository_ruleset" "development" {
  name        = "development"
  repository  = data.github_repository.strata.name
  target      = "branch"
  enforcement = "active"

  conditions {
    ref_name {
      include = ["refs/heads/development"]
      exclude = []
    }
  }

  rules {
    # Nobody pushes directly to development.
    update = true

    # Changes must arrive through a PR.
    pull_request {
      dismiss_stale_reviews_on_push     = true
      require_code_owner_review          = false
      require_last_push_approval         = false
      required_approving_review_count    = 1
      required_review_thread_resolution  = true
    }

    # PR must be tested against the latest development.
    required_linear_history = true

    # Require the speculative validation check.
    required_status_checks {
      strict_required_status_checks_policy = true

      required_check {
        context = "ci/speculative-tests"
      }
    }
  }
}