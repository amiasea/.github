# --- identity.tf ---

# Context for Tenant ID
data "azuread_client_config" "current" {}

# --- APP REGISTRATION ---
resource "azuread_application" "aviator_api" {
  display_name     = "Amiasea Aviator Service"
  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      id                         = "561e1276-8809-4099-a681-42861e69a001"
      value                      = var.api_scope
      admin_consent_display_name = "Control Amiasea"
      admin_consent_description  = "Allows the caller to control Amiasea."
      enabled                    = true
      type                       = "User"
    }
  }

  app_role {
    id                   = "bc712345-6789-4099-a681-42861e69a999"
    allowed_member_types = ["User"]
    description          = "Amiasea Aviator Sovereign"
    display_name         = "Amiasea.Aviator.Sovereign"
    enabled              = true
    value                = "Sovereign"
  }
}

resource "azuread_application_identifier_uri" "aviator_api_uri" {
  application_id = azuread_application.aviator_api.id
  identifier_uri = "api://${azuread_application.aviator_api.client_id}"
}

resource "azuread_service_principal" "aviator_api_sp" {
  client_id = azuread_application.aviator_api.client_id
  # Ensures the URI is registered before the SP is finalized
  depends_on = [azuread_application_identifier_uri.aviator_api_uri]
}

# --- COSMOS DB SETUP ---

resource "azurerm_cosmosdb_account" "amiasea_cosmos" {
  name                = "cosmos-amiasea"
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  free_tier_enabled = true 

  # SECURITY: Entra ID Auth ONLY
  access_key_metadata_writes_enabled = false
  local_authentication_disabled      = true

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
}

resource "azurerm_cosmosdb_sql_database" "amiasea_db" {
  name                = "amiasea"
  resource_group_name = azurerm_cosmosdb_account.amiasea_cosmos.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  throughput          = 1000 # Maxes out the Free Tier benefit
}

resource "azurerm_cosmosdb_sql_container" "actors" {
  name                = "actors"
  resource_group_name = azurerm_cosmosdb_account.amiasea_cosmos.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  database_name       = azurerm_cosmosdb_sql_database.amiasea_db.name
  partition_key_paths = ["/id"]

  indexing_policy {
    indexing_mode = "consistent"
  }
}

# --- PERMISSIONS ---

# 1. API SERVICE PRINCIPAL: Built-in Data Access (Data Plane)
resource "azurerm_cosmosdb_sql_role_assignment" "api_data_access" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  # Built-in "Cosmos DB Built-in Data Contributor"
  role_definition_id  = "${azurerm_cosmosdb_account.amiasea_cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azuread_service_principal.aviator_api_sp.object_id
  scope               = azurerm_cosmosdb_account.amiasea_cosmos.id
}

# 2. ADMIN GROUP: DocumentDB Account Contributor (Control Plane)
resource "azurerm_role_assignment" "cosmos_control_plane_admin" {
  scope                = azurerm_cosmosdb_account.amiasea_cosmos.id
  role_definition_name = "DocumentDB Account Contributor"
  principal_id         = var.amiasea_db_admins_group_id
}

# 3. ADMIN GROUP: Built-in Data Access (Data Plane)
# This allows admins to use Data Explorer in the portal without Master Keys
resource "azurerm_cosmosdb_sql_role_assignment" "admin_data_access" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  role_definition_id  = "${azurerm_cosmosdb_account.amiasea_cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = var.amiasea_db_admins_group_id
  scope               = azurerm_cosmosdb_account.amiasea_cosmos.id
}
