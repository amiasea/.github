data "http" "edm_installation_registry" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.tfe_org_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"

      attributes = {
        name = "edm_installation_registry"

        "vcs-repo" = {
          identifier                   = "amiasea/.github"
          branch                       = "main"
          "github-app-installation-id" = data.tfe_github_app_installation.tfe_cloud_app.id
          "service-provider"           = "github"
        }

        "working-directory" = "terraform/stacks/edm_installation_registry"

        "trigger-patterns" = [
          "terraform/stacks/edm_installation_registry/**/*"
        ]
      }

      relationships = {
        project = {
          data = {
            type = "projects"
            id   = data.tfe_project.amiasea_project.id
          }
        }
      }
    }
  })
}