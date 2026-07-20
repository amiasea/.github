data "azuread_client_config" "current" {}

resource "azuread_group" "sql_admins" {
  display_name     = "Amiasea-SQL-Admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "Members of this group are AD Admins for all vended SQL environments."
}