resource "github_repository" "project_template" {
  name        = "project-repo-template"
  description = "Template for Terraform Project"
  visibility  = "private"
  #   topics      = each.value.topics 
  is_template = true

  security_and_analysis {
    advanced_security {
      status = "enabled"
    }
  }

  auto_init         = true
  source_owner      = "amiasea"
}

