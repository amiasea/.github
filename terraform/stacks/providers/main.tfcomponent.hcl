component "whisper_genie_gh_private_key" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  version = ">= 94.0.0" 

  inputs = {
    secret_name = "amiasea-github-private-key"
  }
  providers = {
    azurerm = provider.azurerm.main
  }
}

component "whisper_genie_tf_token" {
  source  = "app.terraform.io/amiasea/whisper_genie/github"
  version = ">= 94.0.0"

  inputs = {
    secret_name = "tf-token"
  }

  providers = {
    azurerm = provider.azurerm.main
  }
}

component "providers_orchestrator" {
  source  = "app.terraform.io/amiasea/providers/amiasea"
  version = ">= 2.0.0"

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

# Test Change - 6