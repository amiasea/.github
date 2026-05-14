identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment "development" {
  inputs = {
    rg_name = "rg-amiasea-dev"
    environment = "dev"
    location = "eastus" #TODO use standard_b2as_v2 in the module which is available in centralus
    azure_oidc_token = identity_token.azure.jwt
    k8_admin_group_id = store.varset.azure_ids.stable.k8_admin_group_id
    env_subscription_id = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"
  }
}

store "varset" "azure_ids" {
  name     = "Stack-Specific Credentials"
  category = "env"
}