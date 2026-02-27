terraform {
  required_version = ">= 1.6.0"

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0.60.0" # Use a modern version for Project support
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.104.0"
    }
  }
}

provider "tfe" {
  # Authenticates via the TF_TOKEN_app_terraform_io env var you already have
}

provider "hcp" {
  # No arguments needed.
  # Authentication happens via:
  #   - `hcp auth login` (manual, one-time)
  #   - OR HCP_CLIENT_ID / HCP_CLIENT_SECRET (temporary)
}