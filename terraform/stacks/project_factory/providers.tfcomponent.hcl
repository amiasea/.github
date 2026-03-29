required_providers {
  github = {
    source  = "integrations/github"
    version = "~> 6.0"
  }
  tfe = {
    source  = "hashicorp/tfe"
    version = "~> 0.75.0"
  }
  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
}

provider "github" "main" {
  config {
    owner = "amiasea"

    app_auth {
      id              = var.gh_app_id
      installation_id = var.gh_app_installation
      pem_file        = component.genie.outputs.secret_value
    }
  }
}

# provider "tfe" "main" {}

provider "azurerm" "main" {
  config {
    use_oidc = true
    subscription_id = "da348b35-29b6-4906-85ec-4a097aa5fe04"
    client_id = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf"
    tenant_id = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    oidc_token      = var.azure_oidc_token

    features {
    }
  }
}