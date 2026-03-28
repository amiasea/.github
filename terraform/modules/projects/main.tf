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

  auto_init         = false
  source_owner      = "amiasea"
}