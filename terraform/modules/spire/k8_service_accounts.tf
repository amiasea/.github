# The "Brain" identity
resource "kubernetes_service_account" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }
}

# The "Agent" identity (used by the DaemonSet)
resource "kubernetes_service_account" "spire_agent" {
  metadata {
    name      = "spire-agent"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }
}
