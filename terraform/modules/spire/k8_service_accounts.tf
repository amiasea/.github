# The "Brain" identity
resource "kubernetes_service_account_v1" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = "spire"
  }
}

# The "Agent" identity (used by the DaemonSet)
resource "kubernetes_service_account_v1" "spire_agent" {
  metadata {
    name      = "spire-agent"
    namespace = "spire"
  }
}
