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

resource "github_repository" "project_repo" {
  for_each    = var.projects
  name        = each.value
  visibility  = "private"
  #   topics      = each.value.topics
  is_template = false

  template {  
    owner                = "amiasea"
    repository           = github_repository.project_template.name
    include_all_branches = true
  }

  security_and_analysis {
    advanced_security {
      status = "enabled"
    }
  }

  auto_init         = true
  source_owner      = "amiasea"
}

# locals {
#   # Create a map (filename => content) of all files in the 'files' directory
#   content = {
#     for filename in fileset("${path.module}/files", "**") :
#     filename => file("${path.module}/files/${filename}")
#   }
# }

# resource "github_repository_file" "all" {
#   for_each   = local.content
#   repository = github_repository.demo.name
#   file       = each.key    // The filename from the map key
#   content    = each.value  // The file content from the map value
# }