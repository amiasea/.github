resource "random_uuid" "api_scope_id" {}

# --- APP REGISTRATION ---
resource "azuread_application" "amiasea_api" {
  display_name     = "Amiasea Service - ${title(var.env)}"
  sign_in_audience = "AzureADMyOrg"
  prevent_duplicate_names = true

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
  
  lifecycle {
    ignore_changes = [identifier_uris]
  }

  required_resource_access {
    # Target the VC Request Service
    resource_app_id = azuread_service_principal.vc_service.client_id

    resource_access {
      # ID for 'VerifiableCredential.Create.All'
      id   = "949ebb93-18f8-41b4-b677-c2bfea940027" 
      type = "Role"
    }
  }
}

resource "azuread_application_identifier_uri" "amiasea_api_uri" {
  application_id = azuread_application.amiasea_api.id
  identifier_uri = "api://${azuread_application.amiasea_api.client_id}"
}

resource "azuread_service_principal" "amiasea_api_sp" {
  client_id = azuread_application.amiasea_api.client_id
  # Ensures the URI is registered before the SP is finalized
  depends_on = [azuread_application_identifier_uri.amiasea_api_uri]
}

###############################################################

# --- Frontend SPA Registration ---

resource "azuread_application" "amiasea_frontend" {
  display_name     = "Amiasea Frontend - ${title(var.env)}"
  sign_in_audience = "AzureADMyOrg"
  prevent_duplicate_names = true

  single_page_application {
    redirect_uris = [
      "http://localhost:3000/",
      "https://${local.subdomain}.${var.domain}/",
      "https://www.${local.subdomain}.${var.domain}/"
    ]
  }

  # This links the Frontend to the API
  required_resource_access {
    resource_app_id = azuread_application.amiasea_api.client_id

    resource_access {
      # This MUST match the ID of the oauth2_permission_scope in the API
      id   = tolist(azuread_application.amiasea_api.api[0].oauth2_permission_scope)[0].id
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "amiasea_frontend_sp" {
  client_id = azuread_application.amiasea_frontend.client_id
}

# --- THE "TRUST" LINK ---
resource "azuread_application_pre_authorized" "frontend_trust" {
  # This must be the OBJECT ID of the API application
  application_id = azuread_application.amiasea_api.id
  
  # The Client ID of the frontend app is correct here
  authorized_client_id  = azuread_application.amiasea_frontend.client_id
  
  permission_ids        = [tolist(azuread_application.amiasea_api.api[0].oauth2_permission_scope)[0].id]
}

resource "azuread_service_principal_delegated_permission_grant" "frontend_to_api_consent" {
  # WHO is asking? (The Frontend)
  service_principal_object_id = azuread_service_principal.amiasea_frontend_sp.object_id

  # WHAT are they asking to access? (The API)
  resource_service_principal_object_id = azuread_service_principal.amiasea_api_sp.object_id

  # WHICH specific permissions?
  claim_values = [
    var.api_scope # This is the 'value' from your API's oauth2_permission_scope
  ]
}
