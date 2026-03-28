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

provider "github" "main" {}
provider "tfe" "main" {}