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
  ]
}