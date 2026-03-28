# AWS Project Template Repository

This module automates the creation of a standardized, private GitHub repository to be used as a template for Terraform projects within the **amiasea** organization.

## Features

- **Template Enabled**: Sets the `is_template` flag so new projects can be spun up instantly.
- **Security First**: Automatically enables GitHub Advanced Security and Secret Scanning.
- **Standardized Naming**: Ensures all project repos follow the `project-repo-template` naming convention.

## Usage

### Standard Workspace
```hcl
module "project_template" {
  source  = "app.terraform.io/amiasea/project_template_repo/github"
  version = "~> 3.0.0"
}
