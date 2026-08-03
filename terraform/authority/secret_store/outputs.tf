output "key_vault_id" {
  description = "Resource ID of the Authority Key Vault."
  value       = azurerm_key_vault.authority.id
}

output "key_vault_name" {
  description = "Name of the Authority Key Vault."
  value       = azurerm_key_vault.authority.name
}

output "key_vault_uri" {
  description = "URI of the Authority Key Vault."
  value       = azurerm_key_vault.authority.vault_uri
}

output "key_vault_tenant_id" {
  description = "Tenant ID of the Authority Key Vault."
  value       = azurerm_key_vault.authority.tenant_id
}