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