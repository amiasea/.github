# Azure

resource "azuread_application" "amiasea_authority" {
  display_name = "Amiasea-Authority"
}

resource "azuread_service_principal" "amiasea_authority_sp" {
  client_id = azuread_application.amiasea_authority.client_id
}

# AWS

# GCp