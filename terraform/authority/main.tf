data "azurerm_client_config" "current" {}

# --- SOVEREIGN IDENTITIES (UAMI) ---
resource "azurerm_user_assigned_identity" "write" {
  name                = "Amiasea-Write"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = { Plane = "Authority" }
}

resource "azurerm_user_assigned_identity" "read" {
  name                = "Amiasea-Read"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags = { Plane = "Authority" }
}

# --- FEDERATED CREDENTIAL (GitHub → UAMI) ---
resource "azurerm_federated_identity_credential" "github" {
  name                = "amiasea-github"
  resource_group_name = var.resource_group_name
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

# --- CONTAINER APP ENVIRONMENT ---
resource "azurerm_container_app_environment" "main" {
  name                = "cae-amiasea-aviator"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# # --- CONTAINER APP ---
# resource "azurerm_container_app" "aviator_api" {
#   name                         = "ca-amiasea-aviator-api"
#   container_app_environment_id = azurerm_container_app_environment.main.id
#   resource_group_name          = var.resource_group_name
#   revision_mode                = "Single"

#   identity {
#     type         = "UserAssigned"
#     identity_ids = [azurerm_user_assigned_identity.read.id]
#   }

#   secret {
#     name  = "dockerhub-password"
#     value = var.dockerhub_password
#   }

#   registry {
#     server               = "docker.io"
#     username             = var.dockerhub_username
#     password_secret_name = "dockerhub-password"
#   }

#   template {
#     min_replicas = 0
#     max_replicas = 1

#     http_scale_rule {
#       name                = "http-auto-scale"
#       concurrent_requests = "10"
#     }

#     container {
#       name   = "amiasea-api"
#       image  = "${var.dockerhub_username}/amiasea-api:latest"
#       cpu    = 0.25
#       memory = "0.5Gi"

#       env {
#         name  = "AZURE_CLIENT_ID"
#         value = azurerm_user_assigned_identity.read.client_id
#       }
#     }
#   }

#   ingress {
#     external_enabled = true
#     target_port      = 80
#     traffic_weight {
#       percentage      = 100
#       latest_revision = true
#     }
#   }
# }

# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = "kv-amiasea"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_role_assignment" "vault_reader" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.read.principal_id
}