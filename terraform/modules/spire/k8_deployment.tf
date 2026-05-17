resource "kubernetes_deployment_v1" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = "spire"
    labels    = { app = "spire-server" }
  }

  spec {
    replicas = 1
    selector { match_labels = { app = "spire-server" } }

    template {
      metadata { labels = { app = "spire-server" } }

      spec {
        service_account_name = "spire-server"

        container {
          name  = "spire-server"
          image = "ghcr.io/spiffe/spire-server:1.14.5"
          args  = ["run", "-config", "/opt/spire/conf/server/server.conf"]

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
          volume_mount {
            name       = "spire-bundle"
            mount_path = "/run/spire/bundle"
          }
        }

        # spire-controller-manager sidecar (replaces registrar)
        container {
          name  = "spire-controller-manager"
          image = "ghcr.io/spiffe/spire-controller-manager:0.6.4"
          args  = ["--config", "/etc/spire-controller-manager/config.yaml"]

          volume_mount {
            name       = "controller-config"
            mount_path = "/etc/spire-controller-manager/config.yaml"
            sub_path   = "config.yaml"
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
          name = "controller-config"
          config_map { name = "spire-controller-manager-config" }
        }
        volume {
          name = "server-socket"
          empty_dir {}
        }
        volume {
          name = "spire-bundle"
          config_map { name = "spire-bundle" }
        }
      }
    }
  }
  depends_on = [kubernetes_namespace_v1.spire]
}