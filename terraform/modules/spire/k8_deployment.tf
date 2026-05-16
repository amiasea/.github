resource "kubernetes_deployment" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = kubernetes_namespace.spire.metadata[0].name
    labels = {
      app = "spire-server"
    }
  }

  wait_for_rollout = false

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "spire-server"
      }
    }

    template {
      metadata {
        labels = {
          app = "spire-server"
        }
      }

      spec {
        service_account_name = kubernetes_service_account.spire_server.metadata[0].name

        # CONTAINER 1: SPIRE Server
        container {
          name  = "spire-server"
          image = "ghcr.io/spiffe/spire-server:1.8.0"

          # Command-line parameter instructing SPIRE where to look for server.conf
          args = ["run", "-config", "/opt/spire/conf/server/server.conf"]

          env {
            name = "SPIRE_SERVER_DATASTORE_SQL_CONNECTION_STRING"
            value_from {
              secret_key_ref {
                name = "spire-db-config"
                key  = "connection_string"
              }
            }
          }

          port {
            container_port = 8081
          }

          volume_mount {
            name       = "server-config"
            mount_path = "/opt/spire/conf/server/server.conf" # Standard path
            sub_path   = "server.conf"
            read_only  = true
          }

          # Shared socket for the registrar to talk to the server
          volume_mount {
            name       = "server-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }

        # CONTAINER 2: K8s Workload Registrar
        container {
          name  = "k8s-workload-registrar"
          image = "ghcr.io/spiffe/k8s-workload-registrar:1.8.0"
          args  = ["-config", "/run/spire/config/registrar.conf"]

          volume_mount {
            name       = "registrar-config"
            mount_path = "/run/spire/config"
            read_only  = true
          }

          volume_mount {
            name       = "server-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }

        # VOLUME 1: Server Config
        volume {
          name = "server-config"
          config_map {
            name = kubernetes_config_map.spire_server_config.metadata[0].name
          }
        }

        # VOLUME 2: Registrar Config
        volume {
          name = "registrar-config"
          config_map {
            name = kubernetes_config_map.spire_registrar_config.metadata[0].name
          }
        }

        # VOLUME 3: Shared Socket (In-memory pipe between the two containers)
        volume {
          name = "server-socket"
          empty_dir {}
        }
      }
    }
  }

  depends_on = [kubernetes_namespace.spire]
}
