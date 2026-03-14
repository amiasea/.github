resource "random_uuid" "api_scope_id" {}

# --- APP REGISTRATION ---
resource "azuread_application" "aviator_api" {
  display_name     = "Amiasea Aviator Service"
  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      id                         = random_uuid.api_scope_id.result
      value                      = var.api_scope
      admin_consent_display_name = "Control Amiasea"
      admin_consent_description  = "Allows the caller to control Amiasea."
      enabled                    = true
      type                       = "User"
    }
  }

  # Add this block for Verifiable Credentials permissions
  required_resource_access {
    # Resource App ID for 'Verifiable Credentials Service Request'
    resource_app_id = "6a8b4b39-c021-437c-b060-5a14a3fd65f3"

    resource_access {
      # ID for 'VerifiableCredential.Create.All' application permission
      id   = "0efca039-bc61-49cc-9366-89689f506859"
      type = "Role"
    }
  }
}

resource "azuread_application_identifier_uri" "aviator_api_uri" {
  application_id = azuread_application.aviator_api.id
  identifier_uri = "api://${azuread_application.aviator_api.client_id}"
}

resource "azuread_service_principal" "aviator_api_sp" {
  client_id = azuread_application.aviator_api.client_id
  # Ensures the URI is registered before the SP is finalized
  depends_on = [azuread_application_identifier_uri.aviator_api_uri]
}

# Use the official Microsoft App ID for the VC Request service
data "azuread_service_principal" "vc_service" {
  client_id = "49645851-6783-490b-8038-f996d9263654"
}

resource "azuread_app_role_assignment" "vc_consent" {
  # Role: VerifiableCredential.Create.All
  app_role_id         = "949ebb93-18f8-41b4-b677-c2bfea940027" # Correct ID from registry
  principal_object_id = azuread_service_principal.aviator_api_sp.object_id
  
  # This MUST be the Service Principal's Object ID
  resource_object_id  = data.azuread_service_principal.vc_service.object_id
}

###############################################################

# --- Frontend SPA Registration ---

resource "azuread_application" "aviator_frontend" {
  display_name     = "Amiasea Aviator Frontend"
  sign_in_audience = "AzureADMyOrg"

  single_page_application {
    # Replace with your actual frontend URLs
    redirect_uris = ["http://localhost:3000/", "https://app.amiasea.com/"]
  }

  # This links the Frontend to the API
  required_resource_access {
    resource_app_id = azuread_application.aviator_api.client_id

    resource_access {
      # This MUST match the ID of the oauth2_permission_scope in the API
      id   = tolist(azuread_application.aviator_api.api[0].oauth2_permission_scope)[0].id
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "aviator_frontend_sp" {
  client_id = azuread_application.aviator_frontend.client_id
}

# --- THE "TRUST" LINK ---
resource "azuread_application_pre_authorized" "frontend_trust" {
  # This must be the OBJECT ID of the API application
  application_id = azuread_application.aviator_api.id
  
  # The Client ID of the frontend app is correct here
  authorized_client_id  = azuread_application.aviator_frontend.client_id
  
  permission_ids        = [tolist(azuread_application.aviator_api.api[0].oauth2_permission_scope)[0].id]
}

resource "azuread_service_principal_delegated_permission_grant" "frontend_to_api_consent" {
  # WHO is asking? (The Frontend)
  service_principal_object_id = azuread_service_principal.aviator_frontend_sp.object_id

  # WHAT are they asking to access? (The API)
  resource_service_principal_object_id = azuread_service_principal.aviator_api_sp.object_id

  # WHICH specific permissions?
  claim_values = [
    var.api_scope # This is the 'value' from your API's oauth2_permission_scope
  ]
}
