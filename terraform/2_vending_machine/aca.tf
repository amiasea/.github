resource "azurerm_container_app_environment" "main" {
  provider = azuread.sub
  name                = "amiasea-env"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  infrastructure_subnet_id   = azurerm_subnet.subnet.id
  internal_load_balancer_enabled = false

  depends_on = [ azurerm_resource_group.rg ]
}

resource "azurerm_container_app" "aviator_api" {
  name                         = "ca-amiasea-aviator-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.rg.name
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
      image  = "ghcr.io/amiasea/amiasea-api:latest"
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
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # IMPORTANT: Terraform will try to replace this if the value changes in KV
  lifecycle {
    ignore_changes = [
      secret,
      # template[0].container[0].image,
    ]
  }
}

resource "azurerm_container_app" "aviator_ui" {
  name                         = "ca-${var.prefix}-ui-${var.env}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.rg.name
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
      image  = "docker.io/library/alpine:latest"
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "AZURE_CLIENT_ID"
        value = azurerm_user_assigned_identity.uami.client_id
      }
    }
  }

  secret {
    name                = "ghcr-pat"
    key_vault_secret_id = var.ghcr_pat_versionless_id
    identity            = azurerm_user_assigned_identity.uami.id
  }

  registry {
    server               = "ghcr.io"
    username             = "AlfredoBall"
    password_secret_name = "ghcr-pat"
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
}