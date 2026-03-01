output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}

output "wip_name" {
  value = hcp_iam_workload_identity_provider.wip.resource_name
}

output "uami_write_client_id" {
  value = azurerm_user_assigned_identity.write.client_id
}   