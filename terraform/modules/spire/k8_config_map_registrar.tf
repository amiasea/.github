resource "kubernetes_config_map" "spire_registrar_config" {
  metadata {
    name      = "spire-registrar-config"
    namespace = kubernetes_namespace.spire.metadata[0].name
  }

  data = {
    "registrar.conf" = <<EOT
      trust_domain = "${var.environment}.amiasea.com"
      server_socket_path = "/run/spire/sockets/registration.sock"
      cluster = "app-${var.environment}-cluster"
      
      # This ensures IDs are predictable: 
      # spiffe://<domain>/ns/<namespace>/sa/<service-account>
      mode = "service_account"
    EOT
  }
}
