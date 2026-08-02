output "sovereign_client_id" {
  value = azuread_application.amiasea_sovereign.client_id
}

output "sovereign_resource_group_id" {
  value = data.azurerm_resource_group.amiasea_sovereign_rg.id
}

output "sovereign_resource_group_name" {
  value = data.azurerm_resource_group.amiasea_sovereign_rg.name
}

output "sovereign_principal_id" {
  value = data.azuread_service_principal.amiasea_sovereign_sp.object_id
}