

resource "github_repository" "provider_repos" {
  for_each        = toset(var.provider_names)
  name            = "terraform-provider-${each.key}"
  description     = "Managed codebase for custom terraform provider ${each.key}"
  visibility      = "private"
  has_issues      = true
  has_discussions = false
  has_projects    = false
  has_wiki         = false

  template {
    owner                = var.tfe_org_name
    repository           = "terraform-provider-template"
    include_all_branches = false
  }

  depends_on = [github_repository_file.workflow_call]
}

resource "github_actions_variable" "azure_key_name" {
  for_each      = toset(var.provider_names)
  repository    = github_repository.provider_repos[each.key].name
  variable_name = "AZURE_KEY_NAME"
  value         = azurerm_key_vault_key.provider_signer[each.key].name
}

resource "github_actions_variable" "hcp_provider_name" {
  for_each      = toset(var.provider_names)
  repository    = github_repository.provider_repos[each.key].name
  variable_name = "HCP_PROVIDER_NAME"
  value         = tfe_registry_provider.provider_shell[each.key].name
}

# FIX 5: Completely removed fragile un-indexed array lookups.
# The central pipeline workflow file now references your bootstrapped, organization-wide 
# global tracking variable context parameter (`vars.HCP_REGISTRY_GPG_KEY_ID`) natively!
