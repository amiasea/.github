data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

resource "tfe_project" "amiasea" {
  name         = "amiasea"
  organization = var.organization_name
}

resource "tfe_project_settings" "amiasea" {
  project_id             = tfe_project.amiasea.id
  default_execution_mode = "remote"
}

resource "tfe_workspace" "accession" {
  name         = "accession"
  description  = "Workspace for managing the Accession repository"
  organization = var.organization_name
  project_id   = tfe_project.amiasea.id
}

resource "tfe_workspace_settings" "accession" {
  workspace_id   = tfe_workspace.accession.id
  execution_mode = "local"
  auto_apply     = true

  depends_on = [
    tfe_workspace.accession
  ]
}

resource "tfe_workspace" "environment" {
  name         = "environment"
  description  = "Workspace for managing the Environment repository"
  organization = var.organization_name
  project_id   = tfe_project.amiasea.id

  working_directory     = "inception/environment"
  file_triggers_enabled = true
  speculative_enabled   = false

  vcs_repo {
    identifier                 = "${var.organization_name}/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "environment" {
  workspace_id   = tfe_workspace.environment.id
  execution_mode = "remote"
  auto_apply     = true

  depends_on = [
    tfe_workspace.environment
  ]
}

# resource "tfe_workspace" "delegation" {
#   name         = "delegation"
#   description  = "Workspace for managing the Delegation repository"
#   organization = var.organization_name
#   project_id   = tfe_project.amiasea.id

#   working_directory     = "inception/delegation"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }

# resource "tfe_workspace_settings" "delegation" {
#   workspace_id   = tfe_workspace.delegation.id
#   execution_mode = "remote"
#   auto_apply     = true

#   depends_on = [
#     tfe_workspace.delegation
#   ]
# }

# resource "tfe_workspace" "strata" {
#   name         = "strata"
#   description  = "Workspace for managing the Strata repository"
#   organization = var.organization_name
#   project_id   = tfe_project.amiasea.id

#   working_directory     = "inception/strata"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }

# resource "tfe_workspace_settings" "strata" {
#   workspace_id   = tfe_workspace.strata.id
#   auto_apply     = true
#   execution_mode = "remote"

#   depends_on = [
#     tfe_workspace.strata
#   ]
# }

# resource "tfe_workspace" "kitting" {
#   name         = "kitting"
#   description  = "Workspace for managing the Kitting repository"
#   organization = var.organization_name
#   project_id   = tfe_project.amiasea.id

#   working_directory     = "inception/kitting"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }

# resource "tfe_workspace_settings" "kitting" {
#   workspace_id   = tfe_workspace.kitting.id
#   auto_apply     = true
#   execution_mode = "remote"

#   depends_on = [
#     tfe_workspace.kitting
#   ]
# }

# resource "tfe_workspace" "portfolio" {
#   name         = "portfolio"
#   description  = "Workspace for managing the Portfolio repository"
#   organization = var.organization_name
#   project_id   = tfe_project.amiasea.id

#   working_directory     = "inception/portfolio"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }
# }

# resource "tfe_workspace_settings" "portfolio" {
#   workspace_id   = tfe_workspace.portfolio.id
#   auto_apply     = true
#   execution_mode = "remote"

#   depends_on = [
#     tfe_workspace.portfolio
#   ]
# }

resource "tfe_run_trigger" "accession_to_environment" {
  sourceable_id = tfe_workspace.accession.id
  workspace_id  = tfe_workspace.environment.id
}

# resource "tfe_run_trigger" "environment_to_delegation" {
#   sourceable_id = tfe_workspace.environment.id
#   workspace_id  = tfe_workspace.delegation.id
# }

# resource "tfe_run_trigger" "delegation_to_strata" {
#   sourceable_id = tfe_workspace.delegation.id
#   workspace_id  = tfe_workspace.strata.id
# }

# resource "tfe_run_trigger" "strata_to_kitting" {
#   sourceable_id = tfe_workspace.strata.id
#   workspace_id  = tfe_workspace.kitting.id
# }

resource "github_repository" "enterprise_strata" {
  name      = "enterprise-strata"
  auto_init = true
}

resource "github_repository" "enterprise_kitting" {
  name      = "enterprise-kitting"
  auto_init = true
}