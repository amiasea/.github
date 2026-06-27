# --- main.tfdeploy.hcl ---

identity_token "azure" {
  audience = ["api://AzureADTokenExchange"]
}

deployment "global_scaffolding" {
  inputs = {
    azure_oidc_token                = identity_token.azure.jwt
    tfe_org_name                    = "amiasea"
    
    # Custom provider orchestration list matrix array
    provider_names                  = ["aviator"]

    # Pulls corporate values programmatically out of your shared bootstrap varset bucket
    sovereign_azure_tenant_id       = store.varset.shared_bootstrap_set.stable.sovereign_azure_tenant_id
    sovereign_azure_subscription_id = store.varset.shared_bootstrap_set.stable.sovereign_azure_subscription_id
    sovereign_azure_client_id       = store.varset.shared_bootstrap_set.stable.sovereign_azure_client_id
    amiasea_gh_app_id               = store.varset.shared_bootstrap_set.stable.amiasea_gh_app_id
    
    # FIX 1: Removed the un-mapped "_github" substring to form an exact variable set match
    amiasea_github_private_key      = store.varset.shared_bootstrap_set.stable.amiasea_private_key_versionless_id
    
    # FIX 2: Aligned property reference name (Assumes Step 1 was added to the UI varset)
    tf_token                        = store.varset.shared_bootstrap_set.stable.tf_token_versionless_id
  }
}

deployment_auto_approve "safe_provider_expansion" {
  check {
    condition = context.success == true
    reason    = "Compilation steps or validation plans generated failures."
  }
  check {
    condition = context.plan.changes.remove == 0
    reason    = "The execution plan contains explicit resource deletion arguments."
  }
}

store "varset" "shared_bootstrap_set" {
  name     = "Shared Bootstrap Varset"
  category = "terraform"
}
