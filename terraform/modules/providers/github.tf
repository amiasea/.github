resource "github_repository" "provider_template" {
  name             = "terraform-provider-template"
  description      = "Central blueprint template containing centralized upload_providers workflows, workflows, and signing configurations."
  visibility       = "private"
  is_template      = true
  auto_init        = true
  has_issues       = false
  has_discussions  = false
  has_projects     = false
  has_wiki         = false
}

# Step A: Push the central caller pipeline straight into the blueprint template
resource "github_repository_file" "workflow_call" {
  for_each            = toset(var.provider_names)
  
  # DESTINATION REPOSITORY: e.g., terraform-provider-aviator
  repository          = github_repository.provider_repos[each.key].name 
  branch              = "main"
  
  # DESTINATION PATH: This is just a folder path string inside the targeted repo
  file                = ".github/workflows/call_providers_upload.yml"  
  overwrite_on_create = true
  
  # CONTENT SOURCE: Grabs the plaintext from your local computer module files
  content             = file("${path.module}/repo_files/call_providers_upload.yml") 

  depends_on = [github_repository.provider_repos]
}

# Step C: Inject custom asset files directly into child repositories sequentially
resource "github_repository_file" "goreleaser_config" {
  for_each            = toset(var.provider_names)
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = ".goreleaser.yaml"
  overwrite_on_create = true
  content = templatefile("${path.module}/repo_files/.goreleaser.yaml.tmpl", {
    provider_name = each.key
  })

  depends_on = [github_repository.provider_repos]
}

resource "github_repository_file" "go_mod" {
  for_each            = toset(var.provider_names)
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = "go.mod"
  overwrite_on_create = true
  content = templatefile("${path.module}/repo_files/go.mod.tmpl", {
    organization  = var.tfe_org_name
    provider_name = each.key
  })

  depends_on = [github_repository.provider_repos]
}
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
    repository           = github_repository.provider_template.name
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
