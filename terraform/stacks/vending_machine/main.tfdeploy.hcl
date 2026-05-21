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

# deployment "production" {
#   inputs = {
#     env = "prod"
#     location = "centralus"
#     azure_oidc_token = identity_token.azure.jwt
#     sql_admins_group_id = store.varset.azure_ids.stable.sql_admins_group_id
#     ghcr_pat_versionless_id = store.varset.azure_ids.stable.ghcr_pat_versionless_id
#     sovereign_key_vault_id = store.varset.azure_ids.stable.sovereign_key_vault_id
#     env_subscription_id = "d9cd6518-e401-4072-a410-a6a67e9b15f6"
#   }
# }

deployment_auto_approve "no_changes" {
  check {
    # This filters the rule so it only returns true for your 'development' deployment
    condition = context.plan.deployment.deployment_name == "development"
    reason    = "This rule only applies to the development deployment."
  }

    check {
    # This filters the rule so it only returns true for your 'production' deployment
    condition = context.plan.deployment.deployment_name == "production"
    reason    = "This rule only applies to the production deployment."
  }

  check {
    # Safety: Only approve if the plan actually succeeded
    condition = context.success == true
    reason    = "Plan failed; manual review required."
  }

  check {
    # Safety: Prevent auto-destroying resources
    condition = context.plan.changes.remove == 0
    reason    = "Plan includes deletions; manual approval required for safety."
  }
}

store "varset" "azure_ids" {
  name     = "Stack-Specific Credentials"
  category = "terraform"
}