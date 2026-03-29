# Whisper Genie Terraform Module

A lightweight utility module designed to fetch secrets from **Azure Key Vault** and provide them as outputs for your Terraform stacks. 

### Why use this?
*   **Bypass HCP Vault:** Direct integration with Azure Key Vault removes the need for HashiCorp Vault overhead.
*   **State Security:** Helps prevent sensitive values from being stored in plain text within the Terraform state file (when used with `sensitive = true` outputs).

## Usage

```hcl
module "whisper_genie" {
  source      = "app.terraform.io/your-org/whisper-genie/azurerm"
  version     = "1.0.0"

  secret_name = "api-token-production"
}

# Access the secret
locals {
  my_secret = module.whisper_genie.secret_value
}
