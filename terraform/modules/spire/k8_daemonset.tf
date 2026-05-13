resource "kubernetes_daemonset" "spire_agent" {
  metadata {
    name      = "spire-agent"
    namespace = kubernetes_namespace.spire.metadata.name
    labels    = { app = "spire-agent" }
  }

  spec {
    selector {
      match_labels = { app = "spire-agent" }
    }

    template {
      metadata {
        labels = { app = "spire-agent" }
      }

      spec {
        # The Agent needs to see processes on the host to identify them
        host_pid = true
        host_network = true
        dns_policy = "ClusterFirstWithHostNet"

        container {
          name  = "spire-agent"
          image = "ghcr.io/spiffe/spire-agent:1.8.0" # Note: agent-specific image
          args  = ["run", "-config", "/run/spire/config/agent.conf"]

          # The Agent provides a Unix Socket that your apps will connect to
          volume_mount {
            name       = "spire-bundle"
            mount_path = "/run/spire/bundle"
            read_only  = true
          }

          volume_mount {
            name       = "agent-config"
            mount_path = "/run/spire/config"
            read_only  = true
          }

          # This socket is where your apps (API, DB) "ask" for their ID
          volume_mount {
            name       = "spire-agent-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }
        }

        service_account_name = kubernetes_service_account.spire_agent.metadata.name

        volume {
          name = "agent-config"
          config_map {
            name = kubernetes_config_map.spire_agent_config.metadata.name
          }
        }

        # Shared directory on the node so apps can talk to the agent
        volume {
          name = "spire-agent-socket"
          host_path {
            path = "/run/spire/sockets"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "spire-bundle"
          config_map {
            name = "spire-bundle" # Created by the Server automatically
          }
        }
      }
    }
  }
}
