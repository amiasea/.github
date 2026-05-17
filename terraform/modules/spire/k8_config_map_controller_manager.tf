resource "kubernetes_config_map_v1" "spire_controller_manager_config" {
  metadata {
    name      = "spire-controller-manager-config"
    namespace = "spire"
  }

  data = {
    "config.yaml" = <<EOT
apiVersion: spire.spiffe.io/v1alpha1
kind: ControllerManagerConfig
clusterName: "app-${var.environment}-cluster"
trustDomain: "${var.environment}.amiasea.com"

# Optional: Enable default ClusterSPIFFEID (ns/sa style)
clusterSPIFFEID:
  default:
    enabled: true
    spiffeIDTemplate: "spiffe://${var.environment}.amiasea.com/ns/{{ .PodMeta.Namespace }}/sa/{{ .PodSpec.ServiceAccountName }}"
    podSelector: {}
EOT
  }

  depends_on = [kubernetes_namespace_v1.spire]
}