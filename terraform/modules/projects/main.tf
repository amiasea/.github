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

data "github_app_installation" "hcp_terraform" {
  # For the official HCP Terraform App, the slug is "terraform-cloud"
  slug = "terraform-cloud"
}

resource "github_app_installation_repositories" "hcp_tf_permissions" {
  installation_id = data.github_app_installation.hcp_terraform.id

  # Combine the template repo and the new factory repos
  selected_repositories = concat(
    [var.template_repo_name],
    [for repo in github_repository.project_repos : repo.name]
  )

  # Ensure the repos exist before trying to attach them to the App
  depends_on = [
    github_repository.project_repos
  ]
}
