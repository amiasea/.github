component "whisper_genie_gh_private_key" {
  source  = "app.terraform.io/amiasea/whisper-genie/amiasea"
  version = ">= 1.0.0"

  inputs = {
    secret_name = "amiasea-github-private-key"
    key_vault_name      = "kv-amiasea"
    resource_group_name = "rg-amiasea"
  }

  providers = {
    azurerm = provider.azurerm.main
  }
}

component "whisper_genie_client_tf_token" {
  for_each = var.installations

  source  = "app.terraform.io/amiasea/whisper-genie/amiasea"
  version = ">= 1.0.0"

  inputs = {
    secret_name = "${each.value.tfe_organization}-tfe-secret"
    key_vault_name      = "kv-amiasea"
    resource_group_name = "rg-amiasea"
  }

  providers = {
    azurerm = provider.azurerm.main
  }
}

component "helper" {
  for_each = var.installations

  source = "./helper_module"

  inputs = {
    amiasea_gh_app_id          = var.amiasea_gh_app_id
    amiasea_gh_app_private_key = component.whisper_genie_gh_private_key.secret_value
    github_installation_id     = each.key
  }

  providers = {
    github = provider.github.bootstrap
  }
}

component "edm_installation_registry" {
  for_each = var.installations

  source = "./create_installation_module"

  inputs = {
    client_github_organization = each.value.github_organization
    client_tfe_organization    = each.value.tfe_organization
    client_tfe_token           = whisper_genie_client_tf_token[each.key].secret_value
  }

  providers = {
    github = provider.github.client[each.key]
    tfe    = provider.tfe.client[each.key]
  }

  depends_on = [
    component.helper
  ]
}