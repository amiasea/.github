resource "hcp_service_principal" "packer" {
  name = var.hcp_service_principal_name
}

data "hcp_project" "default" {
  project        = var.hcp_project_id
}

resource "hcp_project_iam_binding" "packer_contrib" {
  project_id   = data.hcp_project.default.resource_id
  principal_id = hcp_service_principal.packer.resource_id
  role         = "roles/contributor"  
}

resource "hcp_iam_workload_identity_provider" "github" {
  name              = var.hcp_provider_name
  service_principal = hcp_service_principal.packer.resource_name

  conditional_access = "jwt_claims.repository == `amiasea/.github`"

  oidc = {
    issuer_uri        = "https://token.actions.githubusercontent.com"
    allowed_audiences = ["https://hashicorp.cloud"] 
  }
}

resource "github_actions_organization_variable" "hcp_project_id" {
  variable_name = "HCP_PROJECT_ID"
  value         = data.hcp_project.default.resource_id
  visibility    = "all"
}

resource "github_actions_organization_variable" "hcp_sp_name" {
  variable_name = "HCP_SERVICE_PRINCIPAL_NAME"
  value         = hcp_service_principal.packer.name
  visibility    = "all"
}

resource "github_actions_organization_variable" "hcp_provider_name" {
  variable_name = "HCP_WORKLOAD_IDENTITY_PROVIDER_NAME"
  value         = hcp_iam_workload_identity_provider.github.name
  visibility    = "all"
}