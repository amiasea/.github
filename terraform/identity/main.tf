# --- APP REGISTRATION ---
resource "azuread_application" "aviator_api" {
  display_name     = "Amiasea Aviator Service"
  identifier_uris  = ["api://amiasea-authority"]
  sign_in_audience = "AzureADMyOrg"

  api {
    oauth2_permission_scope {
      id                         = "561e1276-8809-4099-a681-42861e69a001"
      value                      = var.api_scope
      admin_consent_display_name = "Control Amiasea"
      enabled                    = true
      type                       = "User"
    }
  }

  app_role {
    id                   = "bc712345-6789-4099-a681-42861e69a999"
    allowed_member_types = ["User"]
    description          = "Amiasea Aviator Sovereign"
    display_name         = "Amiasea.Aviator.Sovereign"
    enabled              = true
    value                = "Sovereign"
  }
}

resource "azuread_service_principal" "aviator_api_sp" {
  client_id = azuread_application.aviator_api.client_id
}

# --- DIRECTORY ROLE ASSIGNMENT (App Admin) ---
resource "azuread_directory_role_assignment" "uami_id_power" {
  role_id             = "9b89c207-bcdd-4731-b404-20a50955b11a"
  principal_object_id = var.principal_object_id
}