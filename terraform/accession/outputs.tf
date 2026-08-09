output "authority_azure_tenant_id" {
  value = var.authority_azure_tenant_id
}

output "authority_azure_client_id" {
  value = azuread_application.amiasea_authority.client_id
}

output "sovereign_azure_subscription_id" {
  value = var.sovereign_azure_subscription_id
}

output "sovereign_azure_key_vault_id" {
  value = azurerm_key_vault.sovereign_kv.id
}

output "sovereign_azure_resource_group_name" {
  value = azurerm_resource_group.amiasea_sovereign_rg.name
}