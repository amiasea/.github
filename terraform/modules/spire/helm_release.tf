# Main SPIRE deployment
resource "helm_release" "spire" {
  name       = "spire"
  repository = "https://spiffe.github.io/helm-charts-hardened/"
  chart      = "spire"
  namespace  = "spire"

  # Wait for CRDs to be ready
  depends_on = [helm_release.spire_crds]

  values = [yamlencode({
    global = {
      spire = {
        trustDomain = "${var.environment}.amiasea.com"
        clusterName = "app-${var.environment}-cluster"
      }
    }
    spire-server = {
      image = {
        tag = "1.14.5"
      }
      replicaCount = 1
      
      # The hardened chart uses the 'config' block to build the server.conf
      config = {
        plugins = {
          DataStore = [{
            sql = {
              plugin_data = {
                enabled           = true
                database_type     = "postgres"
                connection_string = "host=${neon_endpoint.env_endpoint.host} port=5432 user=${neon_role.spire_owner.name} password=${neon_role.spire_owner.password} dbname=${neon_database.spire_db.name} sslmode=require"
              }
            }
          }]
        }
      }

      controllerManager = {
        enabled     = true
        installCRDs = false
        image = {
          tag = "0.6.4"
        }
      }

      identities = {
        enabled = true
      }
      
      extraEnv = []
    }

    spire-agent = {
      image = {
        tag = "1.14.5"
      }
    }

    spiffe-csi-driver = {
      enabled = true
    }
  })]
}

resource "helm_release" "spire_crds" {
  name             = "spire-crds"
  repository       = "https://spiffe.github.io/helm-charts-hardened/"
  chart            = "spire-crds"
  namespace        = "spire"
  create_namespace = true
  wait             = true
  depends_on       = [kubernetes_namespace_v1.spire]
}