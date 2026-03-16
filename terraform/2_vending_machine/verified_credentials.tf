resource "azuread_service_principal" "vc_service" {
  client_id  = "3db4335c-f09c-497d-b659-1f9e8f6e729a"

  use_existing = true
}

resource "azuread_app_role_assignment" "vc_consent" {
  # Role: VerifiableCredential.Create.All
  app_role_id         = "949ebb93-18f8-41b4-b677-c2bfea940027" # Correct ID from registry
  principal_object_id = azurerm_user_assigned_identity.uami.principal_id
  
  # This MUST be the Service Principal's Object ID
  resource_object_id  = azuread_service_principal.vc_service.object_id
}