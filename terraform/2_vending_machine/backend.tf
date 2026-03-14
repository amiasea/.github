terraform {
  cloud {
    organization = "amiasea"

    workspaces {
      project = "amiasea"
      tags = ["amiasea"]
    }
  }
}
