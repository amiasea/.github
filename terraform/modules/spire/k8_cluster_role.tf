resource "kubernetes_cluster_role_v1" "spire_server_trust" {
  metadata {
    name = "spire-server-trust-role"
  }

  rule {
    api_groups = ["authentication.k8s.io"]
    resources  = ["tokenreviews"]
    verbs      = ["create"]
  }

  rule {
    api_groups = [""]
    resources  = ["nodes", "pods"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = [""]
    resources  = ["serviceaccounts"]
    verbs      = ["get", "list", "watch"]
  }

  # NEW: Allow SPIRE Server to create and update the trust bundle ConfigMap
  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "patch", "update", "create"]
  }
}
