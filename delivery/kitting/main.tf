data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

data "github_repository" "enterprise_kitting" {
  full_name = "${var.organization_name}/enterprise-kitting"
}

resource "github_branch" "enterprise_kitting_main" {
  repository = data.github_repository.enterprise_kitting.name
  branch     = "main"
}

resource "github_branch" "enterprise_kitting_development" {
  repository    = data.github_repository.enterprise_kitting.name
  source_branch = github_branch.enterprise_kitting_main.branch
  branch        = "development"
}

resource "github_branch_default" "default" {
  repository = data.github_repository.enterprise_kitting.name
  branch     = github_branch.enterprise_kitting_main.branch

  depends_on = [
    github_branch.enterprise_kitting_main
  ]
}

data "github_app_token" "app_token" {
  app_id          = var.amiasea_app_id
  installation_id = var.amiasea_app_installation_id
  pem_file        = ephemeral.azurerm_key_vault_secret.amiasea_github_app_private_key.value
}

data "graphql_query" "kitting_projects" {
  query = file("${path.module}/projects.gql")

  query_variables = {
    owner = "amiasea"
    repo  = "kitting"
  }
}

locals {
  kitting_project_names = [
    for project in jsondecode(
      data.graphql_query.kitting_projects.query_response
    ).data.repository.projectsV2.nodes :
    project.title
  ]
}

resource "tfe_project" "kitting" {
  for_each = toset(local.kitting_project_names)

  organization = var.organization_name
  name         = each.value
}

resource "tfe_stack" "kitting_speculative" {
  for_each = tfe_project.kitting

  project_id          = each.value.id
  name                = "kitting_speculative"
  description         = "Speculative stack for testing changes to the ${each.key} development branch"
  speculative_enabled = true
  working_directory   = "terraform/stacks/${each.key}/speculative"

  vcs_repo {
    identifier                 = "${var.organization_name}/${data.github_repository.enterprise_kitting.name}"
    branch                     = github_branch.enterprise_kitting_development.branch
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }

  depends_on = [
    github_branch.enterprise_kitting_development
  ]
}

resource "tfe_stack" "kitting_prospective" {
  for_each = tfe_project.kitting

  project_id          = each.value.id
  name                = "kitting_prospective"
  description         = "Prospective stack for progressing the current ${each.key} engineering-model release"
  speculative_enabled = false
  working_directory   = "terraform/stacks/${each.key}/prospective"

  depends_on = [
    github_branch.enterprise_kitting_development
  ]
}

# SHIM
resource "http" "kitting_prospective_vcs" {
  for_each = tfe_stack.kitting_prospective

  url    = "https://app.terraform.io/api/v2/stacks/${each.value.id}"
  method = "PATCH"

  request_headers = {
    Authorization = "Bearer ${ephemeral.azurerm_key_vault_secret.amiasea_tfe_org_token.value}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"
      id   = each.value.id

      attributes = {
        "vcs-repo" = {
          identifier                   = "${var.organization_name}/${data.github_repository.enterprise_kitting.name}"
          "oauth-token-id"             = ""
          "github-app-installation-id" = data.tfe_github_app_installation.gha_installation.id
          branch                       = ""
          "tags-regex"                 = "candidate-${each.key}"
          "trigger-disabled"           = false
        }
      }
    }
  })

  depends_on = [
    tfe_stack.kitting_prospective
  ]
}

resource "tfe_stack" "kitting_operative" {
  for_each = tfe_project.kitting

  project_id          = each.value.id
  name                = "kitting_operative"
  description         = "Operative stack for managing changes to the ${each.key} main branch"
  speculative_enabled = true
  working_directory   = "terraform/stacks/${each.key}/operative"

  vcs_repo {
    identifier                 = "${var.organization_name}/${data.github_repository.enterprise_kitting.name}"
    branch                     = github_branch.enterprise_kitting_main.branch
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }

  depends_on = [
    github_branch.enterprise_kitting_main
  ]
}