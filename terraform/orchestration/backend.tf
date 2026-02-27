terraform {
  cloud {
    organization = "amiasea"

    workspaces {
      project = "amiasea"
      name = "amiasea-orchestration"
    }
  }
}