resource "kubernetes_config_map_v1" "spire_agent_config" {
  metadata {
    name      = "spire-agent-config"
    namespace = "spire"
  }

  data = {
    "agent.conf" = <<EOT
      agent {
        data_dir = "/run/spire/data"
        log_level = "INFO"
        server_address = "spire-server"
        server_port = "8081"
        socket_path = "/run/spire/sockets/agent.sock"
        trust_bundle_path = "/run/spire/bundle/bundle.crt"
        trust_domain = "${var.environment}.amiasea.com"
      }

      plugins {
        NodeAttestor "k8s_psat" {
          plugin_data {
            cluster = "app-${var.environment}-cluster"
          }
        }

        KeyManager "memory" {
          plugin_data {}
        }

        WorkloadAttestor "k8s" {
          plugin_data {
            # Use skip_kubelet_verification if not using individual node identities
            skip_kubelet_verification = true
          }
        }
      }
    EOT
  }
}
