resource "tfe_workspace" "workspace_dev" {
  name         = "amiasea-dev"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

resource "tfe_workspace" "workspace_prod" {
  name         = "amiasea-prod"
  organization = "amiasea"
  project_id   = data.tfe_project.amiasea.id
}

data "tfe_organization" "organization" {
  name = var.organization_name
}

data "tfe_github_app_installation" "gha_installation" {
  name = data.tfe_organization.organization.name
}

data "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = "amiasea"
}

# 2. Create the variable set (it must NOT be global)
resource "tfe_variable_set" "stack_variable_set" {
  name          = "Stack-Specific Credentials"
  description   = "Secrets scoped to the Spire infrastructure project"
  organization  = "amiasea"
  global        = false 
}

# 3. Apply the set to the PROJECT (This gives Stacks inside access)
resource "tfe_project_variable_set" "project_link" {
  variable_set_id = tfe_variable_set.stack_variable_set.id
  project_id      = data.tfe_project.spire_project.id
}

# 4. Add the variables
resource "tfe_variable" "k8_admin_group_id" {
  key             = "k8_admin_group_id"
  value           = azuread_group.k8_admins.object_id
  category        = "env"
  sensitive       = true
  variable_set_id = tfe_variable_set.stack_variable_set.id
}