resource "kubernetes_deployment_v1" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = "spire"
    labels    = { app = "spire-server" }
  }

  wait_for_rollout = false

  spec {
    replicas = 1
    selector { match_labels = { app = "spire-server" } }
    template {
      metadata { labels = { app = "spire-server" } }
      spec {
        service_account_name = "spire-server"

        container {
          name  = "spire-server"
          image = "ghcr.io/spiffe/spire-server:1.8.0"
          args  = ["run", "-config", "/opt/spire/conf/server/server.conf"]
          
          env {
            name = "SPIRE_SERVER_DATASTORE_SQL_CONNECTION_STRING"
            value_from {
              secret_key_ref {
                name = "spire-db-config"
                key  = "connection_string"
              }
            }
          }

          port { container_port = 8081 }

          volume_mount {
            name       = "server-config"
            mount_path = "/opt/spire/conf/server/server.conf"
            sub_path   = "server.conf"
            read_only  = true
          }

          volume_mount {
            name       = "server-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }

        container {
          name  = "k8s-workload-registrar"
          image = "spiffe/k8s-workload-registrar:1.8.0"
          args  = ["-config", "/run/spire/config/registrar.conf"]
          
          volume_mount {
            name       = "registrar-config"
            mount_path = "/run/spire/config/registrar.conf"
            sub_path   = "registrar.conf"
            read_only  = true
          }

          volume_mount {
            name       = "server-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }

        volume {
          name = "server-config"
          config_map { name = "spire-server-config" }
        }

        volume {
          name = "registrar-config"
          config_map { name = "spire-registrar-config" }
        }

        volume {
          name = "server-socket"
          empty_dir {}
        }
      }
    }
  }
  depends_on = [kubernetes_namespace_v1.spire]
}
