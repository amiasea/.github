terraform {
  required_version = ">= 1.6.0"

  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = ">= 0.104.0"
    }
  }
}

provider "hcp" {
  # No arguments needed.
  # Authentication happens via:
  #   - `hcp auth login` (manual, one-time)
  #   - OR HCP_CLIENT_ID / HCP_CLIENT_SECRET (temporary)
}