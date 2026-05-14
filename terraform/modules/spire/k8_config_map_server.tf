resource "kubernetes_config_map" "spire_server_config" {
  metadata {
    name      = "spire-server-config"
    namespace = kubernetes_namespace.spire.metadata[0].name
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
    }
  }

  NodeAttestor "k8s_psat" {
    plugin_data {
      cluster = "app-${var.environment}-cluster"
    }
  }

  KeyManager "memory" {
    plugin_data {}
  }
}
EOT
  }
}
