output "api_client_id" {
  value       = azuread_application.aviator_api.client_id
  description = "Client ID of the Aviator API application."
}

output "api_scope_name" {
  value       = var.api_scope
  description = "Name of the OAuth2 permission scope."
}