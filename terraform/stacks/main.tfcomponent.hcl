component "repository_factory" {
  # Format: app.terraform.io/<ORG>/<NAME>/<PROVIDER>
  source  = "app.terraform.io/amiasea/module/github"
  version = "~> 1.0" # Stacks can now use semantic versioning

  inputs = {
  }

  providers = {
    github = provider.github.main
  }
}