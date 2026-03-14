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

# 2. Get the Service Principal for the Verifiable Credentials API
resource "azuread_service_principal" "vc_service" {
  client_id = "6a8b4b39-c021-437c-b060-5a14a3fd65f3"
}

# 3. Automatically apply admin consent via role assignment
resource "azuread_app_role_assignment" "vc_consent" {
  app_role_id         = "0efca039-bc61-49cc-9366-89689f506859" # VerifiableCredential.Create.All
  principal_object_id = azuread_service_principal.aviator_api_sp.object_id
  resource_object_id  = azuread_service_principal.vc_service.object_id
}

###############################################################

# --- Frontend SPA Registration ---

resource "azuread_application" "aviator_frontend" {
  display_name     = "Amiasea Aviator Frontend"
  sign_in_audience = "AzureADMyOrg"

  single_page_application {
    # Replace with your actual frontend URLs
    redirect_uris = ["http://localhost:3000", "https://app.amiasea.com"]
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
# Pre-authorizes the frontend so users don't see a consent popup for the API
resource "azuread_application_pre_authorized_applications" "frontend_trust" {
  application_id       = azuread_application.aviator_api.id
  authorized_client_id = azuread_application.aviator_frontend.client_id
  permission_ids       = [tolist(azuread_application.aviator_api.api[0].oauth2_permission_scope)[0].id]
  depends_on           = [azuread_application.aviator_api]
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
