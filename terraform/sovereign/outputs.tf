output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "uami_write_client_id" {
  value = azurerm_user_assigned_identity.write.client_id
}   