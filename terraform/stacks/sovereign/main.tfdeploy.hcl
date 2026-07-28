store "varset" "sovereign" {
  name = "amiasea-sovereign"
  category = "env"
}

identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "default" {
  inputs = {
    sovereign_azure_client_id       = store.varset.sovereign.stable.sovereign_azure_client_id
    sovereign_azure_tenant_id       = store.varset.sovereign.stable.sovereign_azure_tenant_id
    sovereign_azure_subscription_id = store.varset.sovereign.stable.sovereign_azure_subscription_id

    azure_oidc_token = identity_token.azure.jwt

    location            = "centralus"
    resource_group_name = "rg-amiasea"
  }
}