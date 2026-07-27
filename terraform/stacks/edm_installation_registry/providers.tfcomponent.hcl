required_providers {
  github = {
    source  = "integrations/github"
    version = "~> 6.13.0"
  }

  tfe = {
    source  = "hashicorp/tfe"
    version = "~> 0.79.0"
  }

  azurerm = {
    source  = "hashicorp/azurerm"
    version = "~> 4.63.0"
  }
}

provider "github" "bootstrap" {
  config {}
}

provider "github" "client" {
  for_each = var.installations

  config {
    owner = each.value.github_organization
    token = component.helper[each.key].github_token
  }
}

provider "tfe" "client" {
  for_each = var.installations

  config {
    hostname = "app.terraform.io"
    token    = component.whisper_genie_client_tf_token[each.key].secret_value
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