resource "azurerm_linux_function_app" "reconciler" {
  name                = "fn-${var.prefix}-reconciler-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location

  storage_account_name       = azurerm_storage_account.st.name
  storage_account_access_key = azurerm_storage_account.st.primary_access_key
  service_plan_id            = azurerm_service_plan.asp.id

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    "AzureWebJobsStorage"     = azurerm_storage_account.st.primary_connection_string
    "QueueConnectionString"   = azurerm_storage_account.st.primary_connection_string
    # Key Vault Reference for Neon (Postgres)
    "NEON_DB_URL"             = "@Microsoft.KeyVault(SecretUri=${azurerm_key_vault_secret.neon_db.id})"
    # SQL Connection for History table
    "SQL_CONNECTION_STRING"   = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name};Database=${azurerm_mssql_database.db.name};Authentication=Active Directory Managed Identity;"
  }

  site_config {
    application_stack {
      node_version = "18" 
    }
  }
}

resource "azurerm_role_assignment" "kv_access" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_linux_function_app.reconciler.identity.principal_id
}