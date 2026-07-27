identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "default" {
  inputs = {
    amiasea_gh_app_id                 = "2670685"
    installations                     = []
    sovereign_azure_tenant_id         = "bf451fd9-d382-4da8-9c1a-179a96a4d2f3"
    sovereign_azure_subscription_id   = "da348b35-29b6-4906-85ec-4a097aa5fe04"
    sovereign_azure_client_id         = "e5979a4b-0875-4f8c-9688-f9e10a6c7aaf"
    azure_oidc_token                  = identity_token.azure.jwt
  }
}