data "azurerm_key_vault" "vault" {
  name                = "kv-amiasea"
  resource_group_name = "rg-amiasea"
}

data "azurerm_key_vault_secret" "whisper_genie" {
  name         = var.secret_name
  key_vault_id = data.azurerm_key_vault.vault.id
}
 