data "azuread_application" "amiasea_sovereign" {
  display_name = "Amiasea-Sovereign"
}

data "azuread_service_principal" "amiasea_sovereign_sp" {
  client_id = azuread_application.amiasea_sovereign.client_id
}