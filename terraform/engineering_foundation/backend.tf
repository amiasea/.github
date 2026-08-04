terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "amiasea"

    workspaces {
      name = "engineering_foundation"
      project = "amiasea"
    }
  }
}