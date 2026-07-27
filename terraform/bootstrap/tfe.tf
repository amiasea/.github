data "tfe_github_app_installation" "tfe_cloud_app" {
  name = "amiasea"
}

data "tfe_project" "amiasea_project" {
  organization = "amiasea"
  name = "amiasea"
}

output "github_app_installation" {
  value = {
    id   = data.tfe_github_app_installation.tfe_cloud_app.installation_id
    name = data.tfe_github_app_installation.tfe_cloud_app.name
  }
}

resource "tfe_stack" "edm_installation_registry" {
  name       = "edm-installation-registry"
  project_id = data.tfe_project.amiasea_project.id

  vcs_repo {
    identifier                 = "amiasea/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }

  provisioner "local-exec" {
    command = <<EOT
      curl \
        --request PATCH \
        --header "Authorization: Bearer ${var.tfe_org_token}" \
        --header "Content-Type: application/vnd.api+json" \
        --data '{
          "data": {
            "id": "${self.id}",
            "type": "stacks",
            "attributes": {
              "working-directory": "terraform/stacks/edm_installation_registry",
              "trigger-patterns": [
                "terraform/stacks/edm_installation_registry/**/*"
              ]
            }
          }
        }' \
        https://app.terraform.io/api/v2/stacks/${self.id}
    EOT
  }
}

resource "tfe_variable_set" "amiasea_sovereign" {
  name         = "amiasea-sovereign"
  description  = "Azure OIDC coordinates for the Amiasea sovereign stack."
  organization = var.organization_name
  global       = false
}

resource "tfe_project_variable_set" "amiasea_sovereign" {
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  project_id      = data.tfe_project.amiasea_project.id
}

resource "tfe_variable" "sovereign_azure_client_id" {
  key             = "AZURE_CLIENT_ID"
  value           = azuread_application.amiasea_sovereign.client_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_tenant_id" {
  key             = "AZURE_TENANT_ID"
  value           = var.tenant_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}

resource "tfe_variable" "sovereign_azure_subscription_id" {
  key             = "AZURE_SUBSCRIPTION_ID"
  value           = var.subscription_id
  category        = "env"
  variable_set_id = tfe_variable_set.amiasea_sovereign.id
  sensitive       = false
}