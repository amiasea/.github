resource "kubernetes_service_v1" "spire_server" {
  metadata {
    name      = "spire-server"
    namespace = "spire"
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

    depends_on = [kubernetes_namespace_v1.spire]
}
