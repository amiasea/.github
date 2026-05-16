identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment "development" {
  inputs = {
    rg_name = "rg-amiasea-dev"
    environment = "dev"
    location = "centralus"
    vm_size          = "Standard_D2s_v3"      # ← Most reliable for default quota
    os_disk_type     = "Managed"              # D2s_v3 supports Ephemeral poorly with small sizes
    os_disk_size_gb  = 30
    azure_oidc_token = identity_token.azure.jwt
    k8_admin_group_id = store.varset.azure_ids.stable.k8_admin_group_id
    env_subscription_id = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"
  }
}

store "varset" "azure_ids" {
  name     = "Stack-Specific Credentials"
  category = "env"
}