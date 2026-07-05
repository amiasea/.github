component "vending_machine" {
  source  = "app.terraform.io/amiasea/vending_machine/amiasea"
  version = ">= 2.0.0"

  inputs = {
    env = var.env
    location = var.location
    env_subscription_id = var.env_subscription_id
    sql_admins_group_id = var.sql_admins_group_id
    ghcr_pat_versionless_id = var.ghcr_pat_versionless_id
    sovereign_key_vault_id = var.sovereign_key_vault_id
    neon_project_id = var.neon_project_id
    api_image_tag = var.api_image_tag
  }

  providers = {
    azurerm = provider.azurerm.main
    azurerm.sub = provider.azurerm.scoped_sub
    random = provider.random.main
    azuread = provider.azuread.main
    azapi = provider.azapi.main
  }
}