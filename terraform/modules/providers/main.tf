data "azurerm_client_config" "current" {}

# Assumes an Azure Key Vault already exists as your master vault
data "azurerm_key_vault" "master_vault" {
  name                = "kv-amiasea"
  resource_group_name = "rg-amiasea"
}

# 2. Dynamic Key Generation loops here safely because the Stack knows the provider list
resource "azurerm_key_vault_key" "provider_signer" {
  for_each     = toset(var.provider_names)
  name         = "key-sign-${each.key}"
  key_vault_id = data.azurerm_key_vault.master_vault.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["sign", "verify"]
}
