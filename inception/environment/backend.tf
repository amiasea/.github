terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "amiasea"

    workspaces {
      name = "environment"
      project = "amiasea"
    }
  }
}