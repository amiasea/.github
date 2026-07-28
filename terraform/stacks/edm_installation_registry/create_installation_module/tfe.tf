resource "tfe_project" "amiasea" {
  name = "Engineering Delivery Model"
}

resource "tfe_variable_set" "amiasea_set" {
  name         = "Amiasea Varset"
  organization = var.client_tfe_organization
  parent_project_id = data.tfe_project.amiasea.id
  global       = false
}

resource "tfe_variable" "tfe_token" {
  key = "tfe-token"
  value = var.client_tfe_token
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

data "tfe_github_app_installation" "gha_installation" {
  name = var.client_github_organization
}

resource "tfe_stack" "module_catalog_identification" {
  name       = "deployment-catalog-identification-module-catalog"
  project_id = tfe_project.engineering_delivery_model.id

  vcs_repo {
    identifier                 = "${var.client_github_organization}/iac-domain-module-catalog"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.installation_id
  }

  depends_on = [
    github_repository.domain_module_catalog,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      curl \
        --request PATCH \
        --header "Authorization: Bearer ${var.client_tfe_token}" \
        --header "Content-Type: application/vnd.api+json" \
        --data '{
          "data": {
            "id": "${self.id}",
            "type": "stacks",
            "attributes": {
              "vcs-repo": {
                "identifier": "${var.client_github_organization}/iac-domain-module-catalog",
                "github-app-installation-id": "${data.tfe_github_app_installation.gha_installation.installation_id}",
                "working-directory": "terraform/deployment-catalog-identification-module-catalog",
                "trigger-patterns": [
                  "terraform/modules/**/*"
                ]
              }
            }
          }
        }' \
        https://app.terraform.io/api/v2/stacks/${self.id}
    EOT
  }
}

resource "tfe_stack" "stack_catalog_identification" {
  name       = "deployment-catalog-identification-stack-catalog"
  project_id = tfe_project.engineering_delivery_model.id

  vcs_repo {
    identifier                 = "${var.client_github_organization}/iac-domain-stack-catalog"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.installation_id
  }

  depends_on = [
    github_repository.domain_stack_catalog,
  ]

  provisioner "local-exec" {
    command = <<-EOT
      curl \
        --request PATCH \
        --header "Authorization: Bearer ${var.client_tfe_token}" \
        --header "Content-Type: application/vnd.api+json" \
        --data '{
          "data": {
            "id": "${self.id}",
            "type": "stacks",
            "attributes": {
              "vcs-repo": {
                "identifier": "${var.client_github_organization}/iac-domain-stack-catalog",
                "github-app-installation-id": "${data.tfe_github_app_installation.gha_installation.installation_id}",
                "working-directory": "terraform/deployment-catalog-identification-stack-catalog",
                "trigger-patterns": [
                  "terraform/stacks/**/*"
                ]
              }
            }
          }
        }' \
        https://app.terraform.io/api/v2/stacks/${self.id}
    EOT
  }
}

resource "github_repository_file" "tfdeploy" {
  repository          = github_repository.engineering_delivery_model_core.name
  branch              = "main"
  file                = "terraform/stacks/deployment-catalog-registration/main.tfdeploy.hcl"
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

  depends_on = [github_repository.engineering_delivery_model_core]
}

resource "tfe_stack" "deployment_catalog_registration" {
  name       = "deployment-catalog-registration"
  project_id = tfe_project.engineering_delivery_model.id

  vcs_repo {
    identifier = "${var.client_github_organization}/engineering-delivery-model-core"
    branch     = "main"
  }

  depends_on = [
    github_repository.engineering_delivery_model_core,
    github_repository_file.tfdeploy,
    tfe_stack.module_catalog_identification,
    tfe_stack.stack_catalog_identification,
  ]
}

data "http" "deployment_catalog_registration_config" {
  depends_on = [
    tfe_stack.deployment_catalog_registration
  ]

  url    = "https://app.terraform.io/api/v2/stacks/${tfe_stack.deployment_catalog_registration.id}"
  method = "PATCH"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({
    data = {
      id   = tfe_stack.deployment_catalog_registration.id
      type = "stacks"

      attributes = {
        "vcs-repo" = {
          identifier                 = "${var.client_github_organization}/engineering-delivery-model-core"
          "github-app-installation-id" = data.tfe_github_app_installation.gha_installation.installation_id
          branch                     = "main"
          "service-provider"         = "github_app"
        }

        "working-directory" = "terraform/stacks/deployment-catalog-registration"

        "trigger-patterns" = [
          "terraform/stacks/deployment-catalog-registration/**/*"
        ]
      }
    }
  })
}