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
    installations = {
      "149350951" = {
        github_organization = "amiasea-client"
        tfe_organization    = "amiasea-client"
      }
    }
    azure_tenant_id       = store.varset.amiasea_stack_oidc.stable.azure_tenant_id
    azure_subscription_id = store.varset.amiasea_stack_oidc.stable.azure_subscription_id
    azure_client_id       = store.varset.amiasea_stack_oidc.stable.azure_client_id
    azure_oidc_token      = identity_token.azure.jwt
  }
}