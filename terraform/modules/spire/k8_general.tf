resource "kubernetes_namespace" "spire" {
  metadata {
    name = "spire"
  }
}

# Fetch the automatically generated default compute endpoint for your new branch
data "neon_endpoint" "env_endpoint" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
}

resource "kubernetes_secret" "spire_db_config" {
  metadata {
    name      = "spire-db-config"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }

  data = {
    # Schema format: postgresql://<user>:<password>@<endpoint_host>/<database_name>?sslmode=require
    connection_string = "postgresql://${neon_database.spire_db.owner_name}:${data.neon_endpoint.env_endpoint.database_password}@${data.neon_endpoint.env_endpoint.database_host}/${neon_database.spire_db.name}?sslmode=require"
  }
}