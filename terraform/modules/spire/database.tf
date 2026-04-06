data "neon_branch" "root" {
  project_id = var.neon_project_id
  name       = "main" # Neon's default name
}

resource "neon_branch" "env_branch" {
  project_id = var.neon_project_id
  name       = var.environment # "prod", "dev", etc.
  parent_id  = data.neon_branch.root.id
}

# 2. Create the SPIRE database on that branch
resource "neon_database" "spire_db" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
  name       = "spire_server"
  owner_name = "neondb_owner" # Default owner
}