resource "neon_branch" "env_branch" {
  project_id = var.neon_project_id
  name       = var.environment
}

# 2. Create the SPIRE database on that branch
resource "neon_database" "spire_db" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
  name       = "spire_server"
  owner_name = "neondb_owner" # Default owner
}

resource "kubernetes_secret" "spire_db_config" {
  metadata {
    name      = "spire-db-config"
    namespace = "spire"
  }

  data = {
    # Dynamically grab the URI from the Neon provider
    connection_string = neon_branch.env_branch.connection_uri
  }
}