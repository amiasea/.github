required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
  github = {
    source  = "integrations/github"
    version = "~> 6.12.1"
  }
  tfe = {
    source  = "hashicorp/tfe"
    version = "~> 0.78.0"
  }
}

provider "azurerm" "main" {
  config {
    use_oidc        = true
    tenant_id       = var.sovereign_azure_tenant_id
    subscription_id = var.sovereign_azure_subscription_id
    client_id       = var.sovereign_azure_client_id
    oidc_token      = var.azure_oidc_token
    features {}
  }
}

provider "github" "main" {
  config {
    owner = var.tfe_org_name
    # Uses your bootstrapped App identity properties for zero-PAT maintenance loops
    app_auth {
      id              = var.amiasea_gh_app_id
      installation_id = "2670685" # Sourced straight from your organizational profile
      pem_file        = var.amiasea_github_private_key
    }
  }
}

provider "tfe" "main" {
  config {
    hostname = "app.terraform.io"
    token    = var.tf_token
  }
}
