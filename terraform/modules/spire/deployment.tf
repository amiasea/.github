# resource "kubernetes_deployment" "spire_server" {
#   for_each = toset(var.environments)
#   metadata {
#     name      = "spire-server"
#     namespace = "spire"
#     labels    = { app = "spire-server" }
#   }

#   spec {
#     replicas = 1
#     selector { match_labels = { app = "spire-server" } }

#     template {
#       metadata { labels = { app = "spire-server" } }

#       spec {
#         container {
#           name  = "spire-server"
#           image = "ghcr.io/spiffe/spire-server:1.8.0" # Official SPIRE image

#           # Inject the Neon Connection String from our Secret
#           env {
#             name = "SP_DB_URL" # We'll reference this in server.conf
#             value_from {
#               secret_key_ref {
#                 name = kubernetes_secret.spire_db[each.value].metadata[0].name
#                 key  = "connection_string"
#               }
#             }
#           }

#           port { container_port = 8081 } # SPIRE Control Plane
          
#           # We'll use a ConfigMap for the actual server.conf file next
#           volume_mount {
#             name       = "config"
#             mount_path = "/run/spire/config"
#             read_only  = true
#           }
#         }

#         volume {
#           name = "config"
#           config_map {
#             name = "spire-server-config"
#           }
#         }
#       }
#     }
#   }
# }
