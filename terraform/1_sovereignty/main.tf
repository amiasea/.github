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

resource "github_actions_repository_oidc_subject_claim_customization_template" "sovereign" {
  repository  = "amiasea/.github"
  use_default = false
  
  # Use the Organization's template, 
  # Leave include_claim_keys empty to inherit it.
  include_claim_keys = []
}

resource "azuread_application_flexible_federated_identity_credential" "sovereign" {
  application_id = azuread_application.delegated_permissions.id
  display_name   = "vending-machine-lock"
  description    = "Flexible OIDC for GitHub Actions"
  
  issuer    = "https://token.actions.githubusercontent.com"
  audience = "api://AzureADTokenExchange"
  
  # Note: language_version defaults to 1 if not provided
  claims_matching_expression = "claims['sub'] matches '*job_workflow_ref:amiasea/.github/.github/workflows/vending-machine.yml@refs/heads/main*'"
}

# 4. Assign Roles to the Service Principal (NOT the App Reg directly)
resource "azurerm_role_assignment" "sp_contributor" {
  scope                = data.azurerm_subscription.amiasea.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.delegated_permissions_sp.object_id
}
