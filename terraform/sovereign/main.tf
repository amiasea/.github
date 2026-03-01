data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "rg_amiasea" {
  name     = var.resource_group_name
  location = var.location
  tags = { Plane = "Sovereign" }
}

# --- SOVEREIGN IDENTITIES (UAMI) ---
resource "azurerm_user_assigned_identity" "write" {
  name                = "Amiasea-Write"
  resource_group_name = azurerm_resource_group.rg_amiasea.name
  location            = var.location
  tags = { Plane = "Authority" }
}

resource "azurerm_user_assigned_identity" "read" {
  name                = "Amiasea-Read"
  resource_group_name = azurerm_resource_group.rg_amiasea.name
  location            = var.location
  tags = { Plane = "Authority" }
}

# --- FEDERATED CREDENTIAL (GitHub → UAMI) ---
resource "azurerm_federated_identity_credential" "github" {
  resource_group_name = azurerm_resource_group.rg_amiasea.name
  name                = "amiasea-github"
  parent_id           = azurerm_user_assigned_identity.write.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:amiasea/.github:ref:refs/heads/main"
}

# --- SUBSCRIPTION OWNER (ARM POWER) ---
resource "azurerm_role_assignment" "owner" {
  scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.write.principal_id
}

resource "azuread_directory_role_assignment" "write_uami_app_admin" {
  role_id             = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" # Application Administrator
  principal_object_id = azurerm_user_assigned_identity.write.principal_id
}