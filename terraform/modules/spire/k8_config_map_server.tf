resource "kubernetes_config_map_v1" "spire_server_config" {
  metadata {
    name      = "spire-server-config"
    namespace = "spire"
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
      connection_string = "$${SPIRE_SERVER_DATASTORE_SQL_CONNECTION_STRING}"
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
