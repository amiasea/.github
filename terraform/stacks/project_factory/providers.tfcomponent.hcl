# 1. Define which provider plugin to use
required_providers {
  github = {
    source  = "integrations/github"
    version = "~> 6.0"
  }
}

# 2. Instantiate the provider and give it a local name (e.g., "main")
provider "github" "main" {
}