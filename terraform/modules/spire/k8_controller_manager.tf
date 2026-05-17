resource "kubernetes_deployment_v1" "spire_controller_manager" {
  metadata {
    name      = "spire-controller-manager"
    namespace = "spire"
    labels    = { app = "spire-controller-manager" }
  }

  spec {
    replicas = 1
    selector { match_labels = { app = "spire-controller-manager" } }
    template {
      metadata { labels = { app = "spire-controller-manager" } }
      spec {
        service_account_name = "spire-server" # Reusing the server SA for simplicity
        container {
          name  = "controller-manager"
          image = "ghcr.io/spiffe/spire-controller-manager:0.5.0"
          args  = [
            "--config=controller-manager-config.yaml",
          ]
          # Mount the shared socket to talk to the SPIRE Server
          volume_mount {
            name       = "server-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }
        volume {
          name = "server-socket"
          host_path {
            path = "/run/spire/sockets"
            type = "DirectoryOrCreate"
          }
        }
      }
    }
  }
}
