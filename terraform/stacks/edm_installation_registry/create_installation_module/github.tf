resource "github_repository" "engineering_delivery_model_core" {
  name = "engineering-delivery-model-core"

  template {
    owner      = "amiasea"
    repository = "engineering-delivery-model-core-template"
  }
}

resource "github_repository" "iac_domain_module_catalog" {
  name = "iac-domain-module-catalog"

  template {
    owner      = "amiasea"
    repository = "iac-domain-module-catalog-template"
  }
}

resource "github_repository" "iac_domain_stack_catalog" {
  name = "iac-domain-stack-catalog"

  template {
    owner      = "amiasea"
    repository = "iac-domain-stack-catalog-template"
  }
}

resource "github_repository_file" "deployment_catalog_registration_deploy" {
  repository          = github_repository.engineering_delivery_model_core.name
  branch              = "main"
  file                = "terraform/stacks/deployment-catalog-registration/main.tfdeploy.hcl"
  content             = templatefile(
    "${path.module}/main.tfdeploy.hcl.tmpl",
    {
      tfe_organization = var.client_tfe_organization
    }
  )
  commit_message      = "Configure deployment catalog registration"
  overwrite_on_create = true

  depends_on = [
    github_repository.engineering_delivery_model_core,
  ]
}
