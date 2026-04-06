resource "kubernetes_config_map" "spire_bundle" {
  metadata {
    name      = "spire-bundle"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }

  # We leave 'data' empty. 
  # The SPIRE Server (or a sidecar/controller) will populate this dynamically.
  data = {}

  # ADD THIS: Prevents Terraform from fighting SPIRE over the content
  lifecycle {
    ignore_changes = [data]
  }
}