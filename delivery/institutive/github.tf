# resource "github_organization_webhook" "amiasea_global_hook" {
#   active = true

#   configuration {
#     url          = "https://71v2xw9x-5045.use.devtunnels.ms/webhooks/github"
#     content_type = "json"
#     secret       = "amiasea"
#     insecure_ssl = false
#   }

#   # Global organization lifecycle triggers
#   events = ["repository", "member", "organization"]
# }

resource "github_repository_webhook" "strata" {
  repository = "strata"

  configuration {
    url          = "https://71v2xw9x-5045.use.devtunnels.ms/webhooks/github"
    content_type = "json"
    secret       = "amiasea"
    insecure_ssl = false
  }

  active = true

  events = ["pull_request"]
}