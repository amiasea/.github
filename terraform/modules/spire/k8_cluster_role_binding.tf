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
    name      = kubernetes_service_account.spire_server.metadata.name
    namespace = "spire"
  }
}