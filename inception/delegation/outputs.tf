output "sovereign_azure_key_vault_id" {
  value = azurerm_key_vault.sovereign_kv.id
}

output "sovereign_azure_resource_group_name" {
  value = azurerm_resource_group.amiasea_sovereign_rg.name
}