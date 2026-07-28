data "http" "module_catalog_identification" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"

      attributes = {
        name = "deployment-catalog-identification-module-catalog"

        "working-directory" = "terraform/deployment-catalog-identification-module-catalog"

        "trigger-patterns" = [
          "terraform/modules/**/*"
        ]

        "vcs-repo" = {
          identifier                   = "${var.client_github_organization}/iac-domain-module-catalog"
          branch                       = "main"
          "github-app-installation-id" = data.tfe_github_app_installation.tfe_cloud_app.id
          "service-provider"           = "github_app"
        }
      }

      relationships = {
        project = {
          data = {
            type = "projects"
            id   = tfe_project.amiasea.id
          }
        }
      }
    }
  })

  lifecycle {
    postcondition {
      condition     = self.status_code == 201
      error_message = "Failed to create deployment-catalog-identification-module-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }

  depends_on = [
    github_repository.iac_domain_module_catalog,
  ]
}

data "http" "module_catalog_identification_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    jsondecode(data.http.module_catalog_identification.response_body).data.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    data.http.module_catalog_identification,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment-catalog-identification-module-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}

data "http" "stack_catalog_identification" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"

      attributes = {
        name = "deployment-catalog-identification-stack-catalog"

        "working-directory" = "terraform/deployment-catalog-identification-stack-catalog"

        "trigger-patterns" = [
          "terraform/stacks/**/*"
        ]

        "vcs-repo" = {
          identifier                   = "${var.client_github_organization}/iac-domain-stack-catalog"
          branch                       = "main"
          "github-app-installation-id" = data.tfe_github_app_installation.tfe_cloud_app.id
          "service-provider"           = "github_app"
        }
      }

      relationships = {
        project = {
          data = {
            type = "projects"
            id   = tfe_project.amiasea.id
          }
        }
      }
    }
  })

  lifecycle {
    postcondition {
      condition     = self.status_code == 201
      error_message = "Failed to create deployment-catalog-identification-stack-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }

  depends_on = [
    github_repository.iac_domain_stack_catalog,
    data.http.module_catalog_identification_fetch,
  ]
}

data "http" "stack_catalog_identification_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    jsondecode(data.http.stack_catalog_identification.response_body).data.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    data.http.stack_catalog_identification,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment-catalog-identification-stack-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}

data "http" "deployment_catalog_registration" {
  url    = "https://app.terraform.io/api/v2/stacks"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      type = "stacks"

      attributes = {
        name = "deployment_catalog_registration"

        "working-directory" = "terraform/stacks/deployment-catalog-registration"

        "trigger-patterns" = [
          "terraform/stacks/deployment-catalog-registration/**/*"
        ]

        "vcs-repo" = {
          identifier                   = "${var.client_github_organization}/engineering-delivery-model-core"
          branch                       = "main"
          "github-app-installation-id" = data.tfe_github_app_installation.tfe_cloud_app.id
          "service-provider"           = "github_app"
        }
      }

      relationships = {
        project = {
          data = {
            type = "projects"
            id   = tfe_project.amiasea.id
          }
        }
      }
    }
  })

  lifecycle {
    postcondition {
      condition     = self.status_code == 201
      error_message = "Failed to create deployment_catalog_registration Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }

  depends_on = [
    github_repository.engineering_delivery_model_core,
    github_repository_file.tfdeploy,
    data.http.module_catalog_identification_fetch,
    data.http.stack_catalog_identification_fetch,
  ]
}

data "http" "deployment_catalog_registration_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    jsondecode(data.http.deployment_catalog_registration.response_body).data.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    data.http.deployment_catalog_registration,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment_catalog_registration Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}