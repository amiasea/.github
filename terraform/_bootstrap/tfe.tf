data "tfe_github_app_installation" "gha_installation" {
  name = var.organization_name
}

resource "tfe_project" "foundation" {
  organization = var.organization_name
  name         = "foundation"
}

resource "tfe_project" "promotion" {
  organization = var.organization_name
  name         = "promotion"
}

resource "tfe_variable_set" "environment" {
  name        = "environment"
  description = "Environment context for institutive and promotional execution contexts."
}

resource "tfe_project_variable_set" "environment_to_foundation" {
  variable_set_id = tfe_variable_set.environment.id
  project_id      = tfe_project.foundation.id
}

resource "tfe_project_variable_set" "environment_to_promotion" {
  variable_set_id = tfe_variable_set.environment.id
  project_id      = tfe_project.promotion.id
}

# GITHUB

resource "tfe_variable" "amiasea_github_app_id" {
  key             = "GITHUB_APP_ID"
  value           = "2670685"
  category        = "terraform"
  variable_set_id = tfe_variable_set.environment.id
}

resource "tfe_variable" "amiasea_github_app_installation_id" {
  key             = "GITHUB_APP_INSTALLATION_ID"
  value           = "105130264"
  category        = "terraform"
  variable_set_id = tfe_variable_set.environment.id
}

# AZURE

resource "tfe_variable" "tfc_azure_provider_auth_institutive" {
  key             = "TFC_AZURE_PROVIDER_AUTH_INSTITUTIVE"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.environment.id
}

resource "tfe_variable" "tfc_azure_run_client_id_institutive" {
  key             = "TFC_AZURE_RUN_CLIENT_ID_INSTITUTIVE"
  value           = "true"
  category        = "env"
  variable_set_id = tfe_variable_set.environment.id
}

resource "tfe_variable" "tfc_azure_provider_auth_speculative" {
  key             = "TFC_AZURE_PROVIDER_AUTH_SPECULATIVE"
  value           = "55a110cd-185b-4d34-a0c5-e28e59167a31"
  category        = "env"
  variable_set_id = tfe_variable_set.environment.id
}

resource "tfe_variable" "tfc_azure_run_client_id_speculative" {
  key             = "TFC_AZURE_RUN_CLIENT_ID_SPECULATIVE"
  value           = "55a110cd-185b-4d34-a0c5-e28e59167a31"
  category        = "env"
  variable_set_id = tfe_variable_set.environment.id
}

# TFE Provider has a bug

resource "tfe_variable" "azure_environment" {
  key = "azure_environment"

  value = join("\n", [
    "{",
    "  context = \"bf451fd9-d382-4da8-9c1a-179a96a4d2f3\"",
    "  landing_zones = {",
    "    institutive = \"da348b35-29b6-4906-85ec-4a097aa5fe04\"",
    "    speculative = \"bd0f2cca-0676-49e6-a8c2-cae21ea7216b\"",
    "    prospective = \"a1a3e3e6-6a34-455d-b220-f6df7790f905\"",
    "    operative   = \"d9cd6518-e401-4072-a410-a6a67e9b15f6\"",
    "  }",
    "  authority_principal = {",
    "    institutive = \"55a110cd-185b-4d34-a0c5-e28e59167a31\"",
    "    speculative = \"55a110cd-185b-4d34-a0c5-e28e59167a31\"",
    "    prospective = \"55a110cd-185b-4d34-a0c5-e28e59167a31\"",
    "    operative   = \"55a110cd-185b-4d34-a0c5-e28e59167a31\"",
    "  }",
    "}",
    "",
  ])

  category        = "terraform"
  hcl             = true
  variable_set_id = tfe_variable_set.environment.id
}

# AWS

# GCP

# WORKSPACES

resource "tfe_workspace" "strata" {
  name         = "strata"
  description  = "Workspace for managing the Strata delivery mechanics"
  organization = var.organization_name
  project_id   = tfe_project.foundation.id

  working_directory     = "terraform/strata"
  file_triggers_enabled = true
  speculative_enabled   = false

  vcs_repo {
    identifier                 = "${var.organization_name}/.github"
    branch                     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

resource "tfe_workspace_settings" "strata" {
  workspace_id   = tfe_workspace.strata.id
  auto_apply     = true
  execution_mode = "remote"

  depends_on = [
    tfe_workspace.strata
  ]
}

# resource "tfe_workspace" "kitting" {
#   name         = "kitting"
#   description  = "Workspace for managing the Kitting repository"
#   organization = var.organization_name
#   project_id   = tfe_project.foundation.id

#   working_directory     = "terraform/kitting"
#   file_triggers_enabled = true
#   speculative_enabled   = false

#   vcs_repo {
#     identifier                 = "${var.organization_name}/.github"
#     branch                     = "main"
#     github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
#   }

#   depends_on = [ tfe_workspace.strata ]
# }

# resource "tfe_workspace_settings" "kitting" {
#   workspace_id   = tfe_workspace.kitting.id
#   auto_apply     = true
#   execution_mode = "remote"

#   depends_on = [
#     tfe_workspace.kitting
#   ]
# }

# # TRIGGERS

# resource "tfe_run_trigger" "strata_to_kitting" {
#   sourceable_id = tfe_workspace.strata.id
#   workspace_id  = tfe_workspace.kitting.id
# }

resource "tfe_workspace_run" "start_strata" {
  workspace_id = tfe_workspace.strata.id
  apply {
    manual_confirm    = false
    wait_for_run   = true
  }

  # depends_on = [ tfe_workspace.kitting ]
}