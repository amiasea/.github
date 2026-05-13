resource "kubernetes_service" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = kubernetes_namespace.spire.metadata[0].name
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
