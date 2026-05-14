identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment "development" {
  inputs = {
    rg_name = "rg-amiasea-dev"
    environment = "dev"
    location = "centralus"
    azure_oidc_token = identity_token.azure.jwt
    k8_admin_group_id = store.varset.azure_ids.k8_admin_group_id
  }
}

store "varset" "azure_ids" {
  name     = "Stack-Specific Credentials"
  category = "env"
  stable = true
}