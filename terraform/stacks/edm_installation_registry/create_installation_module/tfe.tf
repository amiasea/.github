resource "tfe_project" "amiasea" {
  name = "Amiasea Engineering Delivery Model"
}

resource "tfe_variable_set" "amiasea_set" {
  name             = "Amiasea Varset"
  organization     = var.client_tfe_organization
  parent_project_id = tfe_project.amiasea.id
  global            = false
}

resource "tfe_variable" "tfe_token" {
  key             = "tfe-token"
  value           = var.client_tfe_token
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = var.client_github_organization
}

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
          "service-provider"           = "github"
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
    github_repository.domain_module_catalog,
  ]
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
          "service-provider"           = "github"
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
    github_repository.domain_stack_catalog,
  ]
}

resource "github_repository_file" "tfdeploy" {
  repository = github_repository.engineering_delivery_model_core.name
  branch     = "main"
  file       = "terraform/stacks/deployment-catalog-registration/main.tfdeploy.hcl"

  content = templatefile(
    "${path.module}/deployment-catalog-registration/main.tfdeploy.hcl.tmpl",
    {
      tfe_organization = var.client_tfe_organization
    }
  )

  commit_message      = "Generate main.tfdeploy.hcl with organization name"
  commit_author       = "Terraform"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true

  depends_on = [
    github_repository.engineering_delivery_model_core,
  ]
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
          "service-provider"           = "github"
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
    data.http.module_catalog_identification,
    data.http.stack_catalog_identification,
  ]
}