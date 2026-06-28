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
}

# Step B: Inject baseline GoReleaser config file straight into the template repository
resource "github_repository_file" "goreleaser_config" {
  for_each            = toset(var.provider_names)
  commit_message      = "Managed by Terraform"
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = ".goreleaser.yaml"
  
  overwrite_on_create = true

  content = templatefile("${path.module}/repo_template_files/.goreleaser.yaml.tmpl", {
    provider_name = each.key
  })

  depends_on = [github_repository.provider_repos]
}

resource "github_repository_file" "go_mod" {
  for_each            = toset(var.provider_names)
  commit_message      = "Managed by Terraform"
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = "go.mod"
  
  content = templatefile("${path.module}/repo_template_files/go.mod.tmpl", {
    organization = var.tfe_org_name
    provider_name = each.key
  })

  depends_on = [github_repository.provider_repos]
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