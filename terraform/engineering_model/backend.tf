terraform {
  cloud {
    hostname     = "app.terraform.io"
    organization = "amiasea"

    workspaces {
      name = "engineering_model"
      project = "amiasea"
    }
  }
}