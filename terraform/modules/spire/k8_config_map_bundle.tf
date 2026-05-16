resource "kubernetes_config_map_v1" "spire_bundle" {
  metadata {
    name      = "spire-bundle"
    namespace = kubernetes_namespace.spire.metadata.name
  }

  # We leave 'data' empty. 
  # The SPIRE Server (or a sidecar/controller) will populate this dynamically.
  data = {}

  # Prevents Terraform from fighting SPIRE over the content.

  lifecycle {
    ignore_changes = [data]
  }
}