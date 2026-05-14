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

resource "neon_database" "spire_db" {
  project_id = var.neon_project_id
  branch_id  = neon_branch.env_branch.id
  name       = "spire_server"
  owner_name = neon_role.spire_owner.name

  depends_on = [neon_endpoint.env_endpoint] 
}

resource "neon_database" "spicedb_db" {
  project_id  = var.neon_project_id
  branch_id   = neon_branch.env_branch.id
  name        = "spicedb"
  owner_name  = "neondb_owner"

  depends_on = [neon_endpoint.env_endpoint] 
}