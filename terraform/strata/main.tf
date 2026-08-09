data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

resource "github_branch" "enterprise_strata_main" {
  repository = github_repository.enterprise_strata.name
  branch     = "main"
}

resource "github_branch" "enterprise_strata_development" {
  repository    = github_repository.enterprise_strata.name
  source_branch = github_branch.enterprise_strata_main.branch
  branch        = "development"
}

resource "github_branch_default" "default" {
  repository = github_repository.enterprise_strata.name
  branch     = github_branch.enterprise_strata_main.branch

  depends_on = [
    github_branch.enterprise_strata_main
  ]
}

resource "tfe_stack" "enterprise_strata_speculative" {

  project_id          = data.tfe_project.amiasea_project.id
  name                = "strata_speculative"
  description         = "Speculative stack for testing changes to the strata development branch"
  speculative_enabled = true
  working_directory   = "terraform/stacks/speculative"

  vcs_repo {
    identifier                 = "${var.organization_name}/${github_repository.enterprise_strata.name}"
    branch                     = github_branch.enterprise_strata_development.branch
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }

  depends_on = [
    github_branch.enterprise_strata_development
  ]
}

resource "github_branch_protection_v3" "main_branch_protection" {
  repository     = github_repository.enterprise_strata.name
  branch         = github_branch.enterprise_strata_main.branch

  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  enforce_admins = true

  required_status_checks {
    strict = false
    checks = [
      "source_branch",
      # "prospective_complete",
    ]
  }

  restrictions {
    users = []
    teams = []
    apps  = []
  }
}

resource "tfe_stack" "enterprise_strata_operative" {

  project_id          = data.tfe_project.amiasea_project.id
  name                = "strata_operative"
  description         = "Operative stack for managing changes to the strata main branch"
  speculative_enabled = true
  working_directory   = "terraform/stacks/operative"

  vcs_repo {
    identifier                 = "${var.organization_name}/${github_repository.enterprise_strata.name}"
    branch                     = github_branch.enterprise_strata_main.branch
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }

  depends_on = [
    github_branch.enterprise_strata_main
  ]
}

resource "tfe_stack" "enterprise_strata_prospective" {

  project_id          = data.tfe_project.amiasea_project.id
  name                = "strata_prospective"
  description         = "Prospective stack for progressing the current tagged Strata engineering-model release"
  speculative_enabled = false
  working_directory   = "terraform/stacks/prospective"

  depends_on = [
    github_branch.enterprise_strata_development,
  ]
}

resource "tfe_registry_module" "strata" {
  organization    = var.organization_name
  namespace       = var.organization_name
  name            = "strata"
  module_provider = "terraform"
  registry_name   = "private"

  vcs_repo {
    display_identifier = "${var.organization_name}/${github_repository.enterprise_strata.name}"
    identifier         = "${var.organization_name}/${github_repository.enterprise_strata.name}"
    oauth_token_id     = data.tfe_github_app_installation.gha_installation.id
    tag_prefix         = "module-strata-v"
    tags = true
  }

  depends_on = [
    github_branch.enterprise_strata_development,
  ]
}
