resource "azurerm_container_app_environment" "main" {
  provider = azurerm.sub
  name                = "cae-${var.prefix}-${var.env}"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  depends_on = [ data.azurerm_resource_group.rg ]
}

data "hcp_packer_iteration" "api" {
  bucket_name = "amiasea-api"
  version     = var.api_image_tag  # Maps directly to your exact "api-v1.3.0" Git tag context
}

# 2. Extract the specific artifact properties using the iteration fingerprint
data "hcp_packer_artifact" "api_container" {
  bucket_name         = "amiasea-api"
  version_fingerprint = data.hcp_packer_iteration.api.fingerprint
  platform            = "docker"
  region              = "ghcr.io"
}

resource "azurerm_container_app" "amiasea_api" {
  provider = azurerm.sub
  name                         = "ca-${var.prefix}-api-${var.env}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = data.azurerm_resource_group.rg.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.uami.id]
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
      image  = data.hcp_packer_artifact.api_container.external_identifier
      cpu    = 0.25
      memory = "0.5Gi"

      # Setting 1: DB Connection
      env {
        name  = "SQL_CONNECTION_STRING"
        secret_name = "sql-conn" # References the secret above
      }

      # Setting 2: Verifiable Credentials Authority
      env {
        name  = "VC_AUTHORITY_DID"
        value = "did:ion:your-organization-did-here"
      }

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.uami.client_id
      }
    }
  }

  registry {
    server               = "ghcr.io"
    username             = "AlfredoBall"
    password_secret_name = "ghcr-pat"
  }

  secret {
    name  = "sql-conn"
    value = "Server=tcp:${azurerm_mssql_server.sql.fully_qualified_domain_name},1433;Database=${azurerm_mssql_database.db.name};Authentication=Active Directory Managed Identity;"
  }

  secret {
    name                = "ghcr-pat"
    key_vault_secret_id = var.ghcr_pat_versionless_id
    identity            = azurerm_user_assigned_identity.uami.id
  }

  ingress {
    external_enabled = true
    target_port      = 80

    cors {
      allowed_origins = [
        "https://${local.subdomain}.${var.domain}", 
        "https://www.${local.subdomain}.${var.domain}"
      ]
      allowed_methods = ["GET", "POST", "OPTIONS"]
      allowed_headers = ["*"] 
      exposed_headers = ["*"]
    }
    
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  lifecycle {
    ignore_changes = [
      secret,
      # template[0].container[0].image,
    ]
  }

  depends_on = [ azurerm_role_assignment.sovereign_kv_secrets_user ]
}

resource "azurerm_role_assignment" "api_queue_sender" {
  scope                = azurerm_storage_account.st.id
  role_definition_name = "Storage Queue Data Message Sender"
  principal_id         = azurerm_user_assigned_identity.uami.principal_id
}