resource "github_repository" "engineering_delivery_model_core" {
  name = "engineering-delivery-model-core"

  template {
    owner      = "amiasea"
    repository = "engineering-delivery-model-core-template"
  }
}

resource "github_repository" "domain_module_catalog" {
  name = "domain-module-catalog"

  template {
    owner      = "amiasea"
    repository = "iac-module-catalog-template"
  }
}

resource "github_repository" "domain_stack_catalog" {
  name = "domain-stack-catalog"

  template {
    owner      = "amiasea"
    repository = "iac-stack-catalog-template"
  }
}

resource "github_repository_file" "tfdeploy" {
  repository = github_repository.engineering_delivery_model_core.name
  branch     = "main"
  file       = "terraform/stacks/deployment-catalog-registration/main.tfdeploy.hcl"

  content = templatefile(
    "${path.module}/main.tfdeploy.hcl.tmpl",
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