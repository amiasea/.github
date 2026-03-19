resource "azuread_directory_role_assignment" "admin_dev" {
  role_id             = "f2ef992c-3afb-46b9-b7cf-a696c4fdc05e" # External ID User Flow Admin
  principal_object_id = var.principal_object_id
}

resource "azuread_user_flow_attribute" "organization" {
  display_name = "Organization"
  data_type    = "string"
  description  = "Company or Org name"
}