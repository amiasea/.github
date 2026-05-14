resource "kubernetes_namespace" "spire" {
  metadata {
    name = "spire"
  }
}

resource "neon_role" "spire_owner" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
  name       = "spire_admin"
}

# data "neon_branch_endpoints" "env_endpoints" {
#   project_id = var.neon_project_id
#   branch_id  = neon_branch.env_branch.id

#   depends_on = [neon_database.spire_db] 
# }

# 2. Extract the connection information from the first returned endpoint object
resource "kubernetes_secret" "spire_db_config" {
  metadata {
    name      = "spire-db-config"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }

  data = {
    # Schema format: postgresql://<user>:<password>@<endpoint_host>/<database_name>?sslmode=require
    connection_string = "postgresql://${neon_role.spire_owner.name}:${neon_role.spire_owner.password}@${neon_branch.env_branch.primary_endpoint_host}/${neon_database.spire_db.name}?sslmode=require"
  }
}
