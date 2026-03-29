resource "github_repository" "project_template" {
  name        = "project-repo-template"
  description = "Template for Terraform Project"
  visibility  = "private"

  is_template = true

  auto_init         = true
  source_owner      = "amiasea"
}