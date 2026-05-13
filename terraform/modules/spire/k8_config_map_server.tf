resource "kubernetes_config_map" "spire_server_config" {
  metadata {
    name      = "spire-server-config"
    namespace = kubernetes_namespace.spire.metadata.name
  }

  data = {
    "server.conf" = <<EOT
      server {
        bind_address = "0.0.0.0"
        bind_port = "8081"
        trust_domain = "${var.environment}.amiasea.com"
        data_dir = "/run/spire/data"
        log_level = "INFO"
        socket_path = "/run/spire/sockets/registration.sock" 
      }

      plugins {
        DataStore "sql" {
          plugin_data {
            database_type = "postgres"
            # This env var is injected into the container from the Secret
            connection_string = "$${SP_DB_URL}" 
          }
        }

        NodeAttestor "k8s_psat" {
            plugin_data {
            cluster = "app-${var.environment}-cluster" # Must match the AKS cluster name
            }
        }

        KeyManager "memory" {
            plugin_data {}
        }
      }
    EOT
  }
}
