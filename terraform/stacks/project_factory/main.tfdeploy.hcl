deployment "projects" {
  inputs = {
    project_list = [
    ]
  }

  orchestrate {
    globals {
      variables = {
        GITHUB_OWNER = "amiasea"
      }
    }
  }
}