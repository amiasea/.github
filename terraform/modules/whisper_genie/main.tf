data "azurerm_key_vault" "vault" {
  name                = var.key_vault_name
  resource_group_name = var.resource_group_name
}

data "azurerm_key_vault_secret" "whisper_genie" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.vault.id
}