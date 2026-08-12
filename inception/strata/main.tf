data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name         = "amiasea"
}

data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

data "github_repository" "enterprise_strata" {
  full_name = "${var.organization_name}/enterprise-strata"
}

resource "github_branch" "enterprise_strata_main" {
  repository = data.github_repository.enterprise_strata.name
  branch     = "main"
}

resource "github_branch" "enterprise_strata_development" {
  repository    = data.github_repository.enterprise_strata.name
  source_branch = github_branch.enterprise_strata_main.branch
  branch        = "development"
}

resource "github_branch_default" "default" {
  repository = data.github_repository.enterprise_strata.name
  branch     = github_branch.enterprise_strata_main.branch

  depends_on = [
    github_branch.enterprise_strata_main
  ]
}

resource "github_branch_protection_v3" "main_branch_protection" {
  repository     = data.github_repository.enterprise_strata.name
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

resource "tfe_stack" "enterprise_strata_operative" {

  project_id          = data.tfe_project.amiasea_project.id
  name                = "strata_operative"
  description         = "Operative stack for managing changes to the strata main branch"
  speculative_enabled = true
  working_directory   = "terraform/stacks/operative"

  depends_on = [
    github_branch.enterprise_strata_main
  ]
}

# SHIM
resource "http" "enterprise_strata_prospective_vcs" {
  url    = "https://app.terraform.io/api/v2/stacks/${tfe_stack.enterprise_strata_prospective.id}"
  method = "PATCH"

  request_headers = {
    Authorization = "Bearer ${ephemeral.azurerm_key_vault_secret.amiasea_tfe_org_token.value}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"
      id   = tfe_stack.enterprise_strata_prospective.id

      attributes = {
        "vcs-repo" = {
          identifier                 = "${var.organization_name}/${data.github_repository.enterprise_strata.name}"
          "oauth-token-id"           = ""
          "github-app-installation-id" = data.tfe_github_app_installation.gha_installation.id
          branch                     = ""
          "tags-regex"               = "stack-strata-v"
          "trigger-disabled"         = false
        }
      }
    }
  })

  depends_on = [
    tfe_stack.enterprise_strata_prospective
  ]
}

resource "tfe_registry_module" "strata" {
  organization    = var.organization_name
  namespace       = var.organization_name
  name            = "strata"
  module_provider = "terraform"
  registry_name   = "private"

  vcs_repo {
    display_identifier = "${var.organization_name}/${data.github_repository.enterprise_strata.name}"
    identifier         = "${var.organization_name}/${data.github_repository.enterprise_strata.name}"
    oauth_token_id     = data.tfe_github_app_installation.gha_installation.id
    tag_prefix         = "module-strata-v"
    tags = true
  }

  depends_on = [
    github_branch.enterprise_strata_development,
  ]
}
