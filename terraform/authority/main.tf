# --- CONTAINER APP ENVIRONMENT ---
resource "azurerm_container_app_environment" "main" {
  name                = "cae-amiasea-aviator"
  location            = var.location
  resource_group_name = var.resource_group_name
}

# --- CONTAINER APP ---
resource "azurerm_container_app" "aviator_api" {
  name                         = "ca-amiasea-aviator-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [var.umai_read_id]
  }

  secret {
    name                = "ghcr-pat"
    key_vault_secret_id = "https://kv-amiasea.vault.azure.net" # Use versionless URL for latest
    identity            = var.umai_read_id
  }

  registry {
    server               = "ghcr.io"
    username             = "AlfredoBall"
    password_secret_name = "ghcr-pat"
  }

  template {
    min_replicas = 0
    max_replicas = 1

    http_scale_rule {
      name                = "http-auto-scale"
      concurrent_requests = "10"
    }

    container {
      name   = "amiasea-api"
      image  = "://mcr.microsoft.com"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.read.client_id
      }
    }
  }

  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # IMPORTANT: Terraform will try to replace this if the value changes in KV
  lifecycle {
    ignore_changes = [
      secret,
      template[0].container[0].image,
    ]
  }

  depends_on = [azurerm_role_assignment.vault_reader]
}

# --- KEY VAULT ---
resource "azurerm_key_vault" "vault" {
  name                        = "kv-amiasea"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true
  sku_name                    = "standard"
}

resource "azurerm_role_assignment" "vault_reader" {
  scope                = azurerm_key_vault.vault.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = var.uami_read_principal_id
}