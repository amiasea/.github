terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "amiasea"

    workspaces {
      name = "kitting"
      project = "delivery"
    }
  }
}