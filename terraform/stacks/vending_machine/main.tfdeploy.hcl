identity_token "azure" {
  # This must match the 'Audience' in your Azure Federated Credential
  audience = ["api://AzureADTokenExchange"]
}

deployment "development" {
  inputs = {
    env = "dev"
    location = "centralus"
    azure_oidc_token = identity_token.azure.jwt
    sql_admins_group_id = store.varset.azure_ids.stable.sql_admins_group_id
    ghcr_pat_versionless_id = store.varset.azure_ids.stable.ghcr_pat_versionless_id
    sovereign_key_vault_id = store.varset.azure_ids.stable.sovereign_key_vault_id
    env_subscription_id = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"
  }
}

deployment_auto_approve "no_changes" {
  check {
    condition = context.success == true
    reason    = "Always approve successful plans."
  }
}

store "varset" "azure_ids" {
  name     = "Stack-Specific Credentials"
  category = "env"
}