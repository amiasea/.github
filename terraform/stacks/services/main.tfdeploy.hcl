identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment "projects" {
  inputs = {
    project_list = [
      {
        name :"test"
      }
    ]
    azure_oidc_token = identity_token.azure.jwt
  }
}