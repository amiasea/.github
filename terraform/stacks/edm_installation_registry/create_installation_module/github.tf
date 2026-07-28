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
