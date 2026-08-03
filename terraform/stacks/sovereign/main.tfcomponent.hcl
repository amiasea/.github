component "whisper_genie_amiasea_tf_token" {

  source  = "app.terraform.io/amiasea/whisper_genie/amiasea"
  version = ">= 101.0.0"

  inputs = {
    secret_name         = "tfe-org-token"
    key_vault_name      = "kv-amiasea"
    resource_group_name = "rg-amiasea"
  }

  providers = {
    azurerm = provider.azurerm.main
  }
}

component "whisper_genie_gh_app_private_key" {

  source  = "app.terraform.io/amiasea/whisper_genie/amiasea"
  version = ">= 101.0.0"

  inputs = {
    secret_name         = "amiasea-github-private-key"
    key_vault_name      = "kv-amiasea"
    resource_group_name = "rg-amiasea"
  }

  providers = {
    azurerm = provider.azurerm.main
  }
}

component "sovereign" {
  source = "./amiasea"

  inputs = {
    resource_group_name   = var.resource_group_name
    location              = var.location
    azure_tenant_id       = var.sovereign_azure_tenant_id
    azure_subscription_id = var.sovereign_azure_subscription_id
    tfe_org_token         = whisper_genie_amiasea_tf_token.secret_value
  }

  providers = {
    azurerm = provider.azurerm.main
    tfe = provider.tfe.main
    http = provider.http.main
    azapi = provider.azapi.main
    github = provider.github.main
  }
}
