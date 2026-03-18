# --- 1. SQL SERVER (Entra-Only Auth) ---
resource "azurerm_mssql_server" "sql" {
  provider = azurerm.sub
  name                         = "sql-${var.prefix}-${var.env}"
  resource_group_name          = data.azurerm_resource_group.rg.name
  location                     = var.location
  version                      = "12.0"
  azuread_administrator {
    login_username              = "Entra Admin Group"
    object_id                   = var.sql_admins_group_id
    azuread_authentication_only = true # DISABLES SQL passwords
    tenant_id = data.azurerm_client_config.current.tenant_id
  }

  depends_on = [ data.azurerm_resource_group.rg ]
}

# --- 2. SQL DATABASE (Free Tier) ---
resource "azurerm_mssql_database" "db" {
  name      = "users"
  server_id = azurerm_mssql_server.sql.id
  sku_name  = "Free"
}

# --- 3. RBAC: DATA CONTRIBUTOR ---
resource "azurerm_role_assignment" "api_data_access" {
  scope                = azurerm_mssql_database.db.id
  role_definition_name = "SQL DB Contributor" 
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}