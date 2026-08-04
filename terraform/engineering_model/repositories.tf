resource "github_repository" "enterprise_strata" {
  name = "enterprise-strata"
  auto_init = true
}

resource "github_repository" "enterprise_portfolio" {
  name = "enterprise-portfolio"
  auto_init = true
}

resource "github_repository" "organizational_assembly_run" {
  name = "organizational_assembly_run"
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