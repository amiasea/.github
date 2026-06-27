component "providers_orchestrator" {
  source  = "app.terraform.io/amiasea/providers/github"
  version = ">= 3.0.0"

  inputs = {
    tfe_org_name   = var.tfe_org_name
    provider_names = var.provider_names
  }

  providers = {
    azurerm = provider.azurerm.main
    github  = provider.github.main
    tfe     = provider.tfe.main
  }
}
