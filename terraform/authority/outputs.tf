output "uami_client_id" {
  value       = azurerm_user_assigned_identity.write.client_id
  description = "Client ID of the sovereign UAMI."
}

output "uami_principal_id" {
  value       = azurerm_user_assigned_identity.write.principal_id
  description = "Object ID of the sovereign UAMI."
}

output "subscription_id" {
  value       = data.azurerm_client_config.current.subscription_id
  description = "Subscription ID for downstream identity-plane use."
}