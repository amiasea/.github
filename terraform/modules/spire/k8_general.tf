resource "kubernetes_namespace" "spire" {
  metadata {
    name = "spire"
  }
}

# 1. Fetch endpoints using the correct pluralized data source name
data "neon_branch_endpoints" "env_endpoints" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
}

# 2. Extract the connection information from the first returned endpoint object
resource "kubernetes_secret" "spire_db_config" {
  metadata {
    name      = "spire-db-config"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }

  data = {
    # Schema format: postgresql://<user>:<password>@<endpoint_host>/<database_name>?sslmode=require
    connection_string = "postgresql://${neon_database.spire_db.owner_name}:${data.neon_branch_endpoints.env_endpoints.endpoints[0].database_password}@${data.neon_branch_endpoints.env_endpoints.endpoints[0].host}/${neon_database.spire_db.name}?sslmode=require"
  }
}
