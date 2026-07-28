store "varset" "amiasea_stack_oidc" {
  name     = "amiasea-stack-oidc"
  category = "env"
}
identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "default" {
  inputs = {
    amiasea_gh_app_id     = "2670685"
    installations         = {}
    azure_tenant_id       = store.varset.amiasea_stack_oidc.azure_tenant_id
    azure_subscription_id = store.varset.amiasea_stack_oidc.azure_subscription_id
    azure_client_id       = store.varset.amiasea_stack_oidc.azure_client_id
    azure_oidc_token      = identity_token.azure.jwt
  }
}
