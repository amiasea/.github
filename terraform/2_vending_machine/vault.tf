resource "azapi_resource_action" "sovereign_onboard" {
  resource_id = "/providers/Microsoft.VerifiableCredentials/onboard"
  type        = "Microsoft.VerifiableCredentials/onboard@2021-10-01-preview"
  method      = "POST"

  body = {
    properties = {
      # Your public-facing identity name
      organizationName = "amiasea"
      # Link to the Key Vault we just built
      keyVaultUri      = azurerm_key_vault.vault.vault_uri
    }
  }
}

# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = "kv-${var.prefix}-${var.env}"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  rbac_authorization_enabled  = false

    # Grant the Verified ID Service access to the keys
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azuread_service_principal.vc_service.object_id

    key_permissions = ["Get", "Create", "Sign"]
  }

  network_acls {
    default_action             = "Deny"
    bypass                     = "AzureServices"
    virtual_network_subnet_ids = [azurerm_subnet.subnet.id]
  }
}

resource "azurerm_key_vault_access_policy" "uami_crypto" {
  key_vault_id = azurerm_key_vault.vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.uami.principal_id

  # Equivalent to 'Key Vault Crypto User' permissions
  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Import",
    "Delete",
    "Recover",
    "Backup",
    "Restore",
    "Decrypt",
    "Encrypt",
    "UnwrapKey",
    "WrapKey",
    "Verify",
    "Sign",
    "Purge",
    "Release",
    "Rotate",
    "GetRotationPolicy",
    "SetRotationPolicy"
  ]
}
