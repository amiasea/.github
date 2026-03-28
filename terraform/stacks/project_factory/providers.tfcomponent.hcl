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

variable "gh_app_id" {
  type = string
  default = "2670685"
}

variable "gh_app_installation" {
  type = string
  default = "105130264"
}

variable "gh_app_pem_file" {
  type      = string
  sensitive = true
  ephemeral = true # Won't be stored in state
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
