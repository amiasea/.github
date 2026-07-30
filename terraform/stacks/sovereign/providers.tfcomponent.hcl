required_providers {
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 5.0"
  }
  http = {
    source  = "hashicorp/http"
    version = "~> 3.0"
  }
  tfe = {
    source = "hashicorp/tfe"
    version = "~> 0.79.0"
  }
  azapi = {
    source  = "azure/azapi"
    version = "~> 2.11.0"
  }
  github = {
    source = "integrations/github"
    version = "~> 6.13.0"
  }
}

provider "github" "main" {
  config {
    owner = "amiasea"

    app_auth {
      id              = "2670685"
      installation_id = "105130264"
      pem_file        = component.whisper_genie_gh_app_private_key.secret_value
    }
  }
}

provider "azurerm" "main" {
  config {
    use_oidc = true
    subscription_id = var.sovereign_azure_subscription_id
    tenant_id       = var.sovereign_azure_tenant_id
    client_id       = var.sovereign_azure_client_id
    oidc_token      = var.azure_oidc_token

    features {}
  }
}

provider "azapi" "main" {
  config {
    use_oidc = true
    subscription_id = var.sovereign_azure_subscription_id
    tenant_id       = var.sovereign_azure_tenant_id
    client_id       = var.sovereign_azure_client_id
    oidc_token      = var.azure_oidc_token
  }
}

provider "tfe" "main" {
  config {
    hostname = "app.terraform.io"
    token    = component.whisper_genie_amiasea_tf_token.secret_value
  }
}

provider "http" "main" {}