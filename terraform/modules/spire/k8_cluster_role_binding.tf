resource "kubernetes_cluster_role_binding" "spire_server_trust_binding" {
  metadata {
    name = "spire-server-trust-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.spire_server_trust.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.spire_server.metadata[0].name
    namespace = kubernetes_namespace.spire.metadata[0].name
  }
}