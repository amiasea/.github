identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "global_scaffolding" {
  inputs = {
    azure_oidc_token                = identity_token.azure.jwt
    tfe_org_name                    = "amiasea"
    
    # 🚀 APPEND NEW CUSTOM PROVIDERS HERE!
    # Simply add a string name to this array to scaffold a brand-new repository instantly.
    provider_names                  = ["testprovider"]

    # Pulls corporate values programmatically out of your shared bootstrap varset bucket
    sovereign_azure_tenant_id       = store.varset.shared_bootstrap_set.stable.sovereign_azure_tenant_id
    sovereign_azure_subscription_id = store.varset.shared_bootstrap_set.stable.sovereign_azure_subscription_id
    sovereign_azure_client_id       = store.varset.shared_bootstrap_set.stable.sovereign_azure_client_id
    amiasea_gh_app_id               = store.varset.shared_bootstrap_set.stable.amiasea_gh_app_id
    amiasea_github_private_key      = store.varset.shared_bootstrap_set.stable.amiasea_github_private_key_versionless_id
    tf_token                        = store.varset.shared_bootstrap_set.stable.tf_token_versionless_id
  }
}

# Enforces validation protections to block accidental deletions of provider infrastructure
deployment_auto_approve "safe_provider_expansion" {
  check {
    condition = context.success == true
    reason    = "Compilation steps or validation plans generated failures. Manual investigation forced."
  }
  check {
    condition = context.plan.changes.remove == 0
    reason    = "The execution plan contains explicit resource deletion arguments. Auto-approve blocked."
  }
}

store "varset" "shared_bootstrap_set" {
  name     = "Shared Bootstrap Varset"
  category = "terraform"
}
