data "azurerm_client_config" "current" {}

data "azuread_client_config" "current" {}

data "http" "my_public_ip" {
  url = "https://ifconfig.me"
}

data "azurerm_subscription" "amiasea" {
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_user_assigned_identity" "delegated_permissions" {
  name                = "Amiasea-Delegated-Permissions"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

# Keep Managed Identity Contributor so the UAMI can create other UAMIs if needed
resource "azurerm_role_assignment" "uami_creator" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Managed Identity Contributor"
  principal_id         = azurerm_user_assigned_identity.delegated_permissions.principal_id
}

# 1. Full Power over Resources (Compute, Network, SQL, etc.)
resource "azurerm_role_assignment" "uami_contributor" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.delegated_permissions.principal_id
}

# 2. Full Power over Key Vault Data (Secrets, Keys)
resource "azurerm_role_assignment" "uami_kv_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = azurerm_user_assigned_identity.delegated_permissions.principal_id
}

# 3. Power to assign roles (Needed for your Vending Machine logic)
resource "azurerm_role_assignment" "uami_user_access_admin" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "User Access Administrator"
  principal_id         = azurerm_user_assigned_identity.delegated_permissions.principal_id
}

resource "github_actions_organization_oidc_subject_claim_customization_template" "main" {
  # This tells GitHub to pack these specific pieces of data into the 'sub' claim
  include_claim_keys = [
    "repo",
    "job_workflow_ref",
    "context"
  ]
}

resource "azapi_resource" "sovereign_flexible_credential" {
  depends_on = [ github_actions_organization_oidc_subject_claim_customization_template.main ]
  # Path uses the Application Object ID
  type      = "Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2025-01-31-preview"
  name      = "vending-machine-lock"
  parent_id = azurerm_user_assigned_identity.delegated_permissions.id
  location = var.location

  body = {
    properties = {
      issuer                   = "https://token.actions.githubusercontent.com"
      audiences                = ["api://AzureADTokenExchange"]
      # You cannot provide both 'subject' and 'claimsMatchingExpression'. 
      # Use the expression for your wildcards.
      claimsMatchingExpression = {
        languageVersion = 1
        value = "claims['sub'] matches '*job_workflow_ref:amiasea/.github/.github/workflows/vending-machine.yml@refs/heads/main*'"
        # value = "claims['sub'] matches 'repo:amiasea/.github:ref:refs/heads/*'"
      }
    }
  }
  schema_validation_enabled = false
  response_export_values    = ["*"]
}

# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = var.key_vault_name
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"
  rbac_authorization_enabled  = true
}

resource "azurerm_role_assignment" "terraform_kv_admin" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}

# resource "azurerm_key_vault_secret" "ghcr_pat" {
#   depends_on   = [azurerm_role_assignment.terraform_kv_admin]
#   name         = "ghcr-pat"
#   value        = ""
#   key_vault_id = azurerm_key_vault.vault.id
# }

# resource "azurerm_key_vault_secret" "tf_token" {
#   depends_on   = [azurerm_role_assignment.terraform_kv_admin]
#   name         = "tf-token"
#   value        = ""
#   key_vault_id = azurerm_key_vault.vault.id
# }

# resource "azurerm_key_vault_secret" "amiasea_github_private_key" {
#   depends_on   = [azurerm_role_assignment.terraform_kv_admin]
#   name         = "amiasea-github-private-key"
#   value        = ""
#   key_vault_id = azurerm_key_vault.vault.id
# }

resource "azuread_group" "sql_admins" {
  display_name     = "Amiasea-SQL-Admins"
  owners           = [data.azuread_client_config.current.object_id]
  security_enabled = true
  description      = "Members of this group are AD Admins for all vended SQL environments."
}


# 1. Create the App Registration (The Identity Container)
resource "azuread_application" "delegated_permissions" {
  display_name = "Amiasea-Delegated-Permissions-App"
}

# 2. Create the Service Principal (The 'Login' instance in your tenant)
resource "azuread_service_principal" "delegated_permissions_sp" {
  client_id = azuread_application.delegated_permissions.client_id
}

# 3. Create the Flexible OIDC Credential via Graph API
resource "azapi_resource" "sovereign_flexible_credential" {
  # Format: Microsoft.Graph/applications/<OBJECT_ID>/federatedIdentityCredentials@v1.0
  type      = "Microsoft.Graph/applications/federatedIdentityCredentials@v1.0"
  name      = "vending-machine-lock"
  parent_id = "applications/${azuread_application.delegated_permissions.object_id}"

  # AzAPI 2.0: No jsonencode, fields are at the top level for Graph
  body = {
    name      = "vending-machine-only"
    issuer    = "https://token.actions.githubusercontent.com"
    audiences = ["api://AzureADTokenExchange"]
    
    # This works for App Regs!
    claimsMatchingExpression = "claims['job_workflow_ref'] matches 'amiasea/.github/.github/workflows/vending-machine.yml@refs/heads/main'"
  }
}

# 4. Assign Roles to the Service Principal (NOT the App Reg directly)
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}
