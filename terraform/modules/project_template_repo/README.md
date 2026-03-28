# GitHub Project Template

This module manages the **amiasea** organizational "Golden Image" repository. It provides the standard file structure and security baseline for all subsequent projects created via the Project Factory.

## Features

- **Standardized Blueprint**: Hardcoded as `project-repo-template` to ensure a consistent source for the organization.
- **Is Template**: Enabled via `is_template = true`, allowing developers to manually use the "Use this template" button in the GitHub UI.
- **Security Baseline**: Automatically enables **GitHub Advanced Security** and Secret Scanning upon creation.
- **Day Zero Ready**: Uses `auto_init = true` to create the initial commit and `README.md` so the template is immediately functional.

## Usage

```hcl
module "project_template" {
  source  = "app.terraform.io/amiasea/project_template_repo/github"
  version = "~> 3.0.0"
}
