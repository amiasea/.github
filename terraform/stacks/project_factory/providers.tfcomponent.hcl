required_providers {
  github = {
    source  = "integrations/github"
    version = "~> 6.0"
  }
  tfe = {
    source  = "hashicorp/tfe"
    version = "~> 0.75.0"
  }
}

provider "github" "main" {
  config {
    owner = "amiasea"

    app_auth {
      id              = var.gh_app_id
      installation_id = var.gh_app_installation
      pem_file        = var.gh_app_pem_file
    }
  }
}

provider "tfe" "main" {}
