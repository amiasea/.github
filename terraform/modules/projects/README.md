# GitHub Project Factory

This module acts as the "Engine" for the **amiasea** organization. It takes a list of project definitions and mass-produces private repositories based on a standardized template.

## Features

- **Mass Provisioning**: Uses `for_each` to create multiple repositories in a single execution.
- **Template Inheritance**: Every repo is born from the organizational `project-repo-template`.
- **Enforced Security**: Automatically enables **GitHub Advanced Security** for every repository created.
- **Full History**: Uses `include_all_branches = true` to ensure the new projects have the full context of the template.

## Usage

```hcl
module "projects" {
  source  = "app.terraform.io/amiasea/projects/github"
  version = "~> 1.0.0"

  template_repo_name = "project-repo-template"
  projects = [
    { name = "auth-service" },
    { name = "billing-api", visibility = "internal" }
  ]
}
