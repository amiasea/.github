terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "amiasea"

    workspaces {
      name = "authority"
    }
  }
}