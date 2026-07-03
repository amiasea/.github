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
    app_auth {
      id              = var.amiasea_gh_app_id
      installation_id = "105130264"
      # CROSS-COMPONENT OUTPUT LINK: Pulls the true raw .pem text content from Component A
      pem_file        = component.whisper_genie_gh_private_key.secret_value
    }
  }
}

provider "tfe" "main" {
  config {
    hostname = "app.terraform.io"
    # CROSS-COMPONENT OUTPUT LINK: Pulls the true raw token value from Component B
    token    = component.whisper_genie_tf_token.secret_value
  }
}
