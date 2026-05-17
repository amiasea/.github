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
      connection_string = "host=${neon_endpoint.env_endpoint.host} port=5432 user=${neon_role.spire_owner.name} password=${neon_role.spire_owner.password} dbname=${neon_database.spire_db.name} sslmode=require"
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
