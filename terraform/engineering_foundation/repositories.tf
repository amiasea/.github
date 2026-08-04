resource "github_repository" "enterprise_strata" {
  name = "enterprise-strata"
  auto_init = true
}

resource "github_repository" "organizational_assembly_run" {
  name = "solution-ontologies"
  auto_init = true
}

resource "github_repository" "tactical_delivery_packages" {
  name = "tactical-delivery-packages"
  auto_init = true
}

resource "github_repository" "iac_module_catalog" {
  name      = "iac-module-catalog"
  auto_init = true
}