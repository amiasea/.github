# --- identity.tf ---

# Context for Tenant ID
data "azuread_client_config" "current" {}

# --- APP REGISTRATION ---
resource "azuread_application" "aviator_api" {
  display_name     = "Amiasea Aviator Service"
  sign_in_audience = "AzureADMyOrg"

  api {
    # Setting this to 2 forces Entra to issue tokens that:
    #   Use the oid (Object ID) as the stable unique identifier.
    #   Use the azp (Authorized Party) claim to identify which frontend app is calling.
    #   Are smaller and more standards-compliant than the legacy v1.0 tokens.
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

resource "azuread_service_principal" "aviator_api_sp" {
  client_id = azuread_application.aviator_api.client_id
}

resource "azuread_application_identifier_uri" "aviator_api_uri" {
  application_id = azuread_application.aviator_api.id
  identifier_uri = "api://${azuread_application.aviator_api.client_id}"
}

# --- identity.tf additions ---

# 1. THE COSMOS ACCOUNT (FREE TIER)
resource "azurerm_cosmosdb_account" "amiasea_cosmos" {
  name                = "cosmos-amiasea"
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  # REQUIRED: The Magic Switch for the Lifetime Free Tier
  free_tier_enabled = true 

  # SECURITY: Kill the Master Keys. Force Entra ID ONLY.
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

# 2. THE SOVEREIGN DATABASE
resource "azurerm_cosmosdb_sql_database" "amiasea_db" {
  name                = "amiasea"
  resource_group_name = azurerm_cosmosdb_account.amiasea_cosmos.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  
  # Provision exactly 1000 RU/s to stay in the Free Tier bucket
  throughput = 1000
}

# 3. THE ACTORS CONTAINER (Partitioned by /id for 1.0 RU Point Reads)
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

# 4. DATA ROLE ASSIGNMENT (THE API SERVICE PRINCIPAL)
# This grants your SP "Data Contributor" rights (Built-in ID 000...002)
resource "azurerm_cosmosdb_sql_role_assignment" "api_data_access" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  role_definition_id  = "${azurerm_cosmosdb_account.amiasea_cosmos.id}/sqlRoleDefinitions/00000000-0000-0000-0000-000000000002"
  principal_id        = azuread_service_principal.aviator_api_sp.object_id
  scope               = azurerm_cosmosdb_account.amiasea_cosmos.id
}

# Assign THIS to your Admin Group
resource "azurerm_cosmosdb_sql_role_assignment" "admin_group_elevation" {
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  role_definition_id  = azurerm_cosmosdb_sql_role_definition.sovereign_admin.id
  principal_id        = var.amiasea_db_admins_group_id
  scope               = azurerm_cosmosdb_account.amiasea_cosmos.id
}

resource "azurerm_cosmosdb_sql_role_definition" "sovereign_admin" {
  name                = "Amiasea-Admin"
  resource_group_name = var.resource_group_name
  account_name        = azurerm_cosmosdb_account.amiasea_cosmos.name
  type                = "CustomRole"
  assignable_scopes   = [azurerm_cosmosdb_account.amiasea_cosmos.id]

  permissions {
    data_actions = [
      # 1. Full Data Access (CRUD)
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/*",
      
      # 2. Metadata Access (The "SQL Admin" part)
      # Allows creating/deleting containers and managing throughput via SDK
      "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/*",
      
      # 3. Security Access 
      # Allows the admin to see and manage other RBAC assignments via the Data Plane
      "Microsoft.DocumentDB/databaseAccounts/sqlRoleDefinitions/*",
      "Microsoft.DocumentDB/databaseAccounts/sqlRoleAssignments/*"
    ]
  }
}