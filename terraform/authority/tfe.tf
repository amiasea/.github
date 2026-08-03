resource "tfe_project" "sovereign_project" {
  name = "sovereign"
}

# AZURE

resource "tfe_project_variable_set" "sovereign_azure_oidc" {
  project_id      = tfe_project.sovereign_project.id
  variable_set_id = tfe_variable_set.sovereign_varset_azure_oidc.id
}

resource "tfe_variable_set" "sovereign_varset_azure_oidc" {
  name        = "sovereign-azure-oidc"
  description = "Azure OIDC federation variables for the Sovereign project."

  global = false
}

resource "tfe_variable" "azure_tenant_id" {
  key             = "tenant_id"
  value           = var.tenant_id
  category        = "env"
  sensitive       = false
  variable_set_id = tfe_variable_set.sovereign_varset_azure_oidc.id
}

resource "tfe_variable" "azure_subscription_id" {
  key             = "subscription_id"
  value           = var.subscription_id
  category        = "env"
  sensitive       = false
  variable_set_id = tfe_variable_set.sovereign_varset_azure_oidc.id
}

resource "tfe_variable" "azure_client_id" {
  key             = "client_id"
  value           = module.authentication.sovereign_client_id
  category        = "env"
  sensitive       = false
  variable_set_id = tfe_variable_set.sovereign_varset_azure_oidc.id
}

# AWS

resource "tfe_project_variable_set" "sovereign_aws_oidc" {
  project_id      = tfe_project.sovereign_project.id
  variable_set_id = tfe_variable_set.sovereign_varset_aws_oidc.id
}

resource "tfe_variable_set" "sovereign_varset_aws_oidc" {
  name        = "sovereign-aws-oidc"
  description = "AWS OIDC federation variables for the Sovereign project."

  global = false
}

# GCP

resource "tfe_project_variable_set" "sovereign_gcp_oidc" {
  project_id      = tfe_project.sovereign_project.id
  variable_set_id = tfe_variable_set.sovereign_varset_gcp_oidc.id
}

resource "tfe_variable_set" "sovereign_varset_gcp_oidc" {
  name        = "sovereign-gcp-oidc"
  description = "GCP OIDC federation variables for the Sovereign project."

  global = false
}

# Stacks

data "tfe_github_app_installation" "gha_installation" {
  name = "amiasea"
}

resource "tfe_stack" "sovereign" {
  name        = "sovereign"
  description = "Amiasea Sovereign Stack"

  project_id = tfe_project.sovereign_project.id

  working_directory = "terraform/stacks/sovereign"

  vcs_repo {
    identifier = "amiasea/.github"
    branch     = "main"
    github_app_installation_id = data.tfe_github_app_installation.gha_installation.id
  }
}

data "http" "sovereign_stack_vcs_trigger" {
  url    = "https://app.terraform.io/api/v2/stacks/${tfe_stack.sovereign.id}/fetch-latest-from-vcs"
  method = "POST"

  request_headers = {
    Authorization = "Bearer ${var.amiasea_tfe_org_token}"
    Content-Type  = "application/vnd.api+json"
  }

  depends_on = [ tfe_stack.sovereign ]
}
