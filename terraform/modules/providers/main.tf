variable "provider_name" { type = string }
variable "github_repo_name" { type = string }

data "azurerm_client_config" "current" {}

# Assumes an Azure Key Vault already exists as your master vault
data "azurerm_key_vault" "master_vault" {
  name                = "kv-amiasea"
  resource_group_name = "rg-amiasea"
}

# 1. Fetch your pre-existing organizational master private registry key matrix from the cloud
data "tfe_registry_gpg_keys" "org_keys" {
  organization = var.tfe_org_name
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
