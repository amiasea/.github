resource "github_organization_webhook" "org_global_hook" {
  active = true

  configuration {
    url          = "https://devtunnels.ms"
    content_type = "json"
    secret       = "your-org-level-hmac-secret"
    insecure_ssl = false
  }

  # Global organization lifecycle triggers
  events = ["repository", "member", "organization"]
}