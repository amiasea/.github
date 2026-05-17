resource "kubernetes_config_map_v1" "spire_bundle" {
  metadata {
    name      = "spire-bundle"
    namespace = "spire"
  }

  # We leave 'data' empty. 
  # The SPIRE Server (or a sidecar/controller) will populate this dynamically.
  data = {}

  # Prevents Terraform from fighting SPIRE over the content.

  lifecycle {
    ignore_changes = [data]
  }

  depends_on = [kubernetes_namespace_v1.spire]
}