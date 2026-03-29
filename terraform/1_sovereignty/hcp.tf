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

resource "hcp_service_principal" "deployment_sp" {
  name = "my-app-deployer"
}

resource "hcp_iam_workload_identity_provider" "example" {
  name              = "github-example"
  service_principal = hcp_service_principal.deployment_sp.resource_name
  description       = "Allow acme-repo deploy workflow to access my-app-runtime service principal"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  conditional_access = "<CONDITION>"
}