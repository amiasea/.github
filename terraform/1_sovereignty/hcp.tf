resource "tfe_workspace" "workspace_dev" {
  name         = "amiasea-dev"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

resource "tfe_workspace" "workspace_prod" {
  name         = "amiasea-prod"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_github_app_installation" "gha_installation" {
  name = data.tfe_organization.organization.name
}

# resource "tfe_oauth_client" "test" {
#   name             = "my-github-oauth-client"
#   organization     = "my-org-name"
#   api_url          = "https://api.github.com"
#   http_url         = "https://github.com"
#   oauth_token      = "my-vcs-provider-token"
#   service_provider = "github"
#   organization_scoped = true
# }

data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}

locals {
  # Path to the local credentials file
  creds_file = pathexpand("~/.terraform.d/credentials.tfrc.json")
  
  # Decode the file and grab the token for app.terraform.io
  # Use try() to avoid errors if the file doesn't exist yet
  tfe_token = try(jsondecode(file(local.creds_file))["credentials"]["app.terraform.io"]["token"], "")
}

data "github_repository" "app_repo" {
  full_name = "amiasea/.github"
}

resource "tfe_stack" "test-stack" {
  name                = "my-stack"
  description         = "A Terraform Stack using two components with two environments"
  project_id          = data.tfe_project.amiasea.id
  speculative_enabled = true

  vcs_repo {
    branch         = "main"
    identifier     = "amiasea/.github"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}