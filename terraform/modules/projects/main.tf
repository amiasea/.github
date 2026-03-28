resource "github_repository" "project_repos" {
  for_each = { for p in var.projects : p.name => p }

  name        = each.value.name
  visibility  = "private"
  is_template = false

  security_and_analysis {
    advanced_security {
      status = "enabled"
    }
  }

  template {
    owner                = "amiasea"
    repository           = var.template_repo_name
    include_all_branches = true
  }

  auto_init    = false
  source_owner = "amiasea"
}

# This is now a TFE data source
data "tfe_github_app_installation" "hcp_terraform" {
  name = "amiasea"
}

resource "github_app_installation_repositories" "hcp_tf_permissions" {
  # The GitHub provider resource uses the ID found by the TFE data source
  installation_id = data.tfe_github_app_installation.hcp_terraform.installation_id

  selected_repositories = concat(
    [var.template_repo_name],
    [for repo in github_repository.project_repos : repo.name]
  )
}
