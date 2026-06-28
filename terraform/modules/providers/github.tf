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

resource "github_repository_file" "workflow_call" {
  repository          = github_repository.provider_template.name
  branch              = "main"
  file                = ".github/workflows/call_providers_upload.yml"
  overwrite_on_create = true
  
  content             = file("${path.module}/repo_template_files/call_providers_upload.yml")

  depends_on = [github_repository.provider_template]
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

  depends_on = [github_repository.provider_template]
}

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
}

resource "github_repository_file" "license" {
  for_each            = toset(var.provider_names)

  commit_message      = "Managed by Terraform"
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = "LICENSE"
  
  content = file("${path.module}/repo_template_files/LICENSE")
}

resource "github_repository_file" "tools" {
  for_each            = toset(var.provider_names)

  commit_message      = "Managed by Terraform"
  repository          = github_repository.provider_repos[each.key].name
  branch              = "main"
  file                = "tools/tools.go"
  
  content = templatefile("${path.module}/repo_template_files/tools.go.tmpl", {})
}

resource "github_repository_file" "main_go" {
  for_each   = toset(var.provider_names)
  
  commit_message = "Managed by Terraform: Seeded main provider execution block with automated tfplugindocs compiler hook (Terraform)"
  repository = github_repository.provider_repos[each.key].name
  branch     = "main"
  file       = "main.go"
  
  content = templatefile("${path.module}/repo_template_files/main.go.tmpl", {
    provider_name     = each.key
    namespace         = "amiasea"
    registry_hostname = "app.terraform.io"
  })
}

resource "github_repository_file" "magefile" {
  for_each = toset(var.provider_names)

  commit_message = "Managed by Terraform: Seed templated Mage build file"
  repository     = github_repository.provider_repos[each.key].name
  branch         = "main"
  file           = "magefile.go"

  content = templatefile("${path.module}/repo_template_files/magefile.go.tmpl", {
    provider_name = each.key
  })
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