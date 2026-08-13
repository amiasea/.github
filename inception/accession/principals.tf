# Azure

resource "azuread_application" "amiasea_authority" {
  display_name = "Amiasea-Authority"
  prevent_duplicate_names = true
}

resource "azuread_service_principal" "amiasea_authority_sp" {
  client_id = azuread_application.amiasea_authority.client_id
  use_existing = true
}

# AWS

# GCp