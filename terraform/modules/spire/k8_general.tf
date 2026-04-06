resource "kubernetes_namespace" "spire" {
  metadata {
    name = "spire"
  }
}

resource "kubernetes_secret" "spire_db_config" {
  metadata {
    name      = "spire-db-config"
    namespace = "spire"
  }

  data = {
    # Dynamically grab the URI from the Neon provider
    connection_string = neon_branch.env_branch.connection_uri
  }
}