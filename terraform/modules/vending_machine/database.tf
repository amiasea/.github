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

data "neon_branches" "all" {
  project_id = var.neon_project_id
}
  
locals {
  # Filters the list of branches to find the one designated as primary (the root)
  root_branch = [for b in data.neon_branches.all.branches : b if b.primary][0]
}

resource "neon_branch" "env_branch" {
  project_id = var.neon_project_id
  name       = var.environment # "prod", "dev", etc.
  parent_id  = local.root_branch.id
}

resource "neon_endpoint" "env_endpoint" {
  project_id              = var.neon_project_id
  branch_id               = neon_branch.env_branch.id
  type                    = "read_write" #
  suspend_timeout_seconds = 0              # Prevents Neon compute from sleeping during active K8s runtimes
}

resource "neon_database" "spicedb_db" {
  project_id  = var.neon_project_id
  branch_id   = neon_branch.env_branch.id
  name        = "spicedb"
  owner_name  = "neondb_owner"

  depends_on = [neon_endpoint.env_endpoint] 
}