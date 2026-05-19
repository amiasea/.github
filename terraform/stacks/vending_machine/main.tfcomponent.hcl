component "vending_machine" {
  source  = "app.terraform.io/amiasea/vending_machine/github"
  version = ">= 9.0.0" 

  inputs = {
    env = var.env
    location = var.location
    env_subscription_id = var.env_subscription_id
    sql_admins_group_id = var.sql_admins_group_id
    ghcr_pat_versionless_id = var.ghcr_pat_versionless_id
    sovereign_key_vault_id = var.sovereign_key_vault_id
  }

  providers = {
    azurerm = provider.azurerm.main
    azurerm.sub = provider.azurerm.scoped_sub
    random = provider.random.main
    azuread = provider.azuread.main
    azapi = provider.azapi.main
  }
}