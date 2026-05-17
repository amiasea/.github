resource "kubernetes_cluster_role_binding_v1" "spire_server_trust_binding" {
  metadata {
    name = "spire-server-trust-binding"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "spire-server-trust-role"
  }
  subject {
    kind      = "ServiceAccount"
    name      = "spire-server"
    namespace = "spire"
  }

  depends_on = [
    kubernetes_namespace_v1.spire,
    kubernetes_cluster_role_v1.spire_server_trust
  ]
}