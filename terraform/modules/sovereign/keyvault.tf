# --- KEY VAULT ---
resource "azurerm_key_vault" "sovereign_vault" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  sku_name                   = "standard"
  rbac_authorization_enabled = true

  network_acls {
    # Poor Option
    default_action = "Allow"
    bypass         = "AzureServices"
  }
}

resource "azurerm_key_vault_secret" "ghcr_pat" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "ghcr-pat"
  value_wo         = "SSOVEREIGN CEREMONY"
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}

resource "azurerm_key_vault_secret" "tf_token" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "tf-token"
  value_wo         = "SOVEREIGN CEREMONY"
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}

resource "azurerm_key_vault_secret" "amiasea_github_private_key" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "amiasea-github-private-key"
  value_wo         = "SOVEREIGN CEREMONY"
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}

resource "azurerm_key_vault_secret" "neon_org_api_key" {
  depends_on       = [azurerm_role_assignment.terraform_kv_admin]
  name             = "neon-org-api-key"
  value_wo         = "SOVEREIGN CEREMONY"
  value_wo_version = 1
  key_vault_id     = azurerm_key_vault.sovereign_vault.id
}

resource "azurerm_key_vault_key" "provider_signer" {
  name         = "provider-signing-key"
  key_vault_id = azurerm_key_vault.sovereign_vault.id
  key_type     = "RSA"
  key_size     = 4096

  key_opts = [
    "sign",
    "verify",
  ]
}