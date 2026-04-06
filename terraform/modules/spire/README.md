# Neon Spire Terraform Module

A specialized utility module designed to provision a dedicated **Neon** database branch and automatically inject the connection string into a **Kubernetes Secret** for SPIRE deployments.

### Why use this?
*   **Serverless SPIRE Backend:** Leverages Neon’s serverless Postgres to provide a highly available backend for SPIRE without managing database clusters.
*   **Environment Isolation:** Automatically creates a unique Neon branch for each environment (e.g., staging, production) to ensure strict data separation.
*   **GitOps Ready:** Streamlines the handshake between your cloud database and Kubernetes by handling the secret creation in a single step.

## Usage

```hcl
module "spire_db" {
  source          = "app.terraform.io/your-org/spire-neon/kubernetes"
  version         = "1.0.0"

  environment     = "production"
  neon_project_id = "rapid-water-123456"
}
