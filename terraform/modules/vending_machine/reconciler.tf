resource "azurerm_linux_function_app" "reconciler" {
  name                = "fn-${var.prefix}-reconciler-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.asp.id

  # Use ONLY the name and the Identity flag
  storage_account_name          = azurerm_storage_account.st.name
  storage_uses_managed_identity = true

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    # System logic now uses accountName instead of a connection string
    "AzureWebJobsStorage__accountName" = azurerm_storage_account.st.name
    
    # Custom Identity-based Queue Connection
    "QueueConnection__queueServiceUri" = "https://${azurerm_storage_account.st.name}.queue.core.windows.net"
    
    # Neon & SQL
    "REBAC_DB_URL"          = "host=${neon_endpoint.env_endpoint.host} port=5432 user=${neon_role.spire_owner.name} password=${neon_role.spire_owner.password} dbname=${neon_database.spire_db.name} sslmode=require"
    "SQL_CONNECTION_STRING" = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};Authentication=Active Directory Managed Identity;"
  }

  site_config {
    application_stack {
      node_version = "18"
    }
  }
}

# Permission for the Function's internal WebJobs state (Blobs)
resource "azurerm_role_assignment" "reconciler_storage_owner" {
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = azurerm_linux_function_app.reconciler.identity[0].principal_id
}

# Permission for the Function's internal WebJobs state (Queues)
resource "azurerm_role_assignment" "reconciler_storage_queue_owner" {
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Queue Data Contributor"
  principal_id         = azurerm_linux_function_app.reconciler.identity[0].principal_id
}

# Allow Reconciler to process messages
resource "azurerm_role_assignment" "reconciler_queue_processor" {
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Queue Data Message Processor"
  principal_id         = azurerm_linux_function_app.reconciler.identity[0].principal_id
}

# Allow Reconciler to write to the SQL History table
resource "azurerm_role_assignment" "reconciler_sql" {
  scope                = azurerm_mssql_database.db.id
  role_definition_name = "SQL DB Contributor"
  principal_id         = azurerm_linux_function_app.reconciler.identity[0].principal_id
}