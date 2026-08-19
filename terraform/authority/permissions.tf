resource "azuread_directory_role" "global_administrator" {
  display_name = "Global Administrator"
}

resource "azuread_directory_role_assignment" "amiasea_authority_global_administrator" {
  role_id             = azuread_directory_role.global_administrator.template_id
  principal_object_id = azuread_service_principal.amiasea_authority_sp.object_id
}