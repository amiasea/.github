# Replace with an existing service principal if created ahead of time.
resource "hcp_service_principal" "deployment_sp" {
  name = "platform"
}

resource "hcp_iam_workload_identity_provider" "example" {
  name              = "github"
  service_principal = hcp_service_principal.deployment_sp.resource_name
  description       = "Allow acme-repo deploy workflow to access my-app-deployer service principal"

  oidc = {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }

  conditional_access = "jwt_claims.repository == `amiasea/.github` and jwt_claims.ref == `refs/heads/main`"
}

resource "hcp_project" "amiasea_project" {
  name        = "amiasea"
  description = "Managed by GitHub OIDC automation"
}

resource "hcp_project_iam_binding" "sp_admin" {
  project_id   = hcp_project.amiasea_project.resource_id
  principal_id = hcp_service_principal.deployment_sp.resource_id
  role         = "roles/admin"
}