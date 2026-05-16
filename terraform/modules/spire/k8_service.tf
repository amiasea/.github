resource "kubernetes_service_v1" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = kubernetes_namespace.spire.metadata.name
  }

  spec {
    selector = {
      app = "spire-server"
    }

    port {
      name        = "grpc"
      port        = 8081
      target_port = 8081
      protocol    = "TCP"
    }

    type = "ClusterIP"
  }
}
