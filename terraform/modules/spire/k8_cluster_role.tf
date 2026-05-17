resource "kubernetes_cluster_role_v1" "spire_server_trust" {
  metadata {
    name = "spire-server-trust-role"
  }

  # === SPIRE Server Core Permissions ===
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

  rule {
    api_groups = [""]
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "create", "patch", "update"]
  }

  # === SPIRE Controller Manager Permissions ===
  rule {
    api_groups = ["spire.spiffe.io"]
    resources  = [
      "clusterspiffeids",
      "clusterstaticentries",
      "clusterfederatedtrustdomains",
      "controllermanagerconfigs"
    ]
    verbs = ["*"]
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "namespaces", "configmaps"]
    verbs      = ["get", "list", "watch", "patch", "update"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "statefulsets", "daemonsets"]
    verbs      = ["get", "list", "watch"]
  }

  # Optional but recommended for full functionality
  rule {
    api_groups = [""]
    resources  = ["events"]
    verbs      = ["create", "patch"]
  }
}