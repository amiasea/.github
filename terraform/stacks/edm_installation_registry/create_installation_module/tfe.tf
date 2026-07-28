resource "tfe_project" "amiasea" {
  organization = var.client_tfe_organization
  name = "Amiasea Engineering Delivery Model"
}

resource "tfe_variable_set" "amiasea_set" {
  name             = "amiasea"
  organization     = var.client_tfe_organization
  parent_project_id = tfe_project.amiasea.id
  global            = false
}

resource "tfe_variable" "tfe_token" {
  key             = "tfe_token"
  value           = var.client_tfe_token
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

resource "tfe_variable" "tfe_organization" {
  key             = "tfe_organization"
  value           = var.client_tfe_organization
  category        = "terraform"
  variable_set_id = tfe_variable_set.amiasea_set.id
}

data "tfe_github_app_installation" "tfe_cloud_app" {
  name = var.client_github_organization
}

resource "tfe_stack" "module_catalog_identification" {
  name       = "deployment-catalog-identification-module-catalog"
  project_id = tfe_project.amiasea.id

  working_directory = "terraform/deployment-catalog-identification-module-catalog"

  trigger_patterns = [
    "terraform/modules/**/*"
  ]

  vcs_repo {
    identifier                 = "${var.client_github_organization}/iac-domain-module-catalog"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }

  depends_on = [
    github_repository.iac_domain_module_catalog,
  ]
}

resource "tfe_stack" "stack_catalog_identification" {
  name       = "deployment-catalog-identification-stack-catalog"
  project_id = tfe_project.amiasea.id

  working_directory = "terraform/deployment-catalog-identification-stack-catalog"

  trigger_patterns = [
    "terraform/stacks/**/*"
  ]

  vcs_repo {
    identifier                 = "${var.client_github_organization}/iac-domain-stack-catalog"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }

  depends_on = [
    github_repository.iac_domain_stack_catalog,
  ]
}

resource "tfe_stack" "deployment_catalog_registration" {
  name       = "deployment_catalog_registration"
  project_id = tfe_project.amiasea.id

  working_directory = "terraform/stacks/deployment-catalog-registration"

  trigger_patterns = [
    "terraform/stacks/deployment-catalog-registration/**/*"
  ]

  vcs_repo {
    identifier                 = "${var.client_github_organization}/engineering-delivery-model-core"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.tfe_cloud_app.id
  }

  depends_on = [
    github_repository.engineering_delivery_model_core,
    github_repository_file.deployment_catalog_registration_deploy
  ]
}

data "http" "module_catalog_identification_vcs_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    tfe_stack.module_catalog_identification.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    tfe_stack.module_catalog_identification,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment-catalog-identification-module-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}

data "http" "stack_catalog_identification_vcs_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    tfe_stack.stack_catalog_identification.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    tfe_stack.stack_catalog_identification,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment-catalog-identification-stack-catalog Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}

data "http" "deployment_catalog_registration_vcs_fetch" {
  url = "https://app.terraform.io/api/v2/stacks/${
    tfe_stack.deployment_catalog_registration.id
  }/fetch-latest-from-vcs"

  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.client_tfe_token}"
    Content-Type  = "application/vnd.api+json"
  }

  request_body = jsonencode({})

  depends_on = [
    tfe_stack.deployment_catalog_registration,
  ]

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Failed to fetch latest configuration for deployment_catalog_registration Stack. HTTP status: ${self.status_code}. Response: ${self.response_body}"
    }
  }
}