resource "kubernetes_daemonset" "spire_agent" {
  metadata {
    name      = "spire-agent"
    namespace = "spire"
    labels    = { app = "spire-agent" }
  }

  spec {
    selector { match_labels = { app = "spire-agent" } }
    template {
      metadata { labels = { app = "spire-agent" } }
      spec {
        host_pid     = true
        host_network = true
        dns_policy   = "ClusterFirstWithHostNet"
        service_account_name = "spire-agent"

        container {
          name  = "spire-agent"
          image = "ghcr.io/spiffe/spire-agent:1.8.0"
          args  = ["run", "-config", "/opt/spire/conf/agent/agent.conf"]

          volume_mount {
            name       = "agent-config"
            mount_path = "/opt/spire/conf/agent/agent.conf"
            sub_path   = "agent.conf"
            read_only  = true
          }

          volume_mount {
            name       = "spire-agent-socket"
            mount_path = "/run/spire/sockets"
            read_only  = false
          }

          volume_mount {
            name       = "spire-bundle"
            mount_path = "/run/spire/bundle"
            read_only  = true
          }
        }

        volume {
          name = "agent-config"
          config_map { name = "spire-agent-config" }
        }

        volume {
          name = "spire-agent-socket"
          host_path {
            path = "/run/spire/sockets"
            type = "DirectoryOrCreate"
          }
        }

        volume {
          name = "spire-bundle"
          config_map { name = "spire-bundle" }
        }
      }
    }
  }
}
