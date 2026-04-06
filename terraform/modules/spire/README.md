# SPIRE & SpiceDB Terraform Module (Neon-Backed)

A comprehensive identity and authorization module for Kubernetes. This module provisions a high-availability **SPIRE** (SPIFFE) stack for service identity and a **SpiceDB** (ReBAC) engine for fine-grained permissions, all backed by a dedicated **Neon Postgres** environment branch.

## Architecture Highlights
*   **Identity (SPIRE):** Uses `k8s_psat` node attestation and a `k8s-workload-registrar` sidecar for zero-touch SPIFFE ID issuance.
*   **Authorization (SpiceDB):** High-performance ReBAC engine using gRPC to provide consistent permission checks for .NET services.
*   **Database (Neon):** Implements an "Empty Root" branching strategy. All data lives on environment-specific branches (e.g., `prod`, `dev`) isolated from the main branch.
*   **Deterministic IDs:** Configured for `service_account` mode, producing predictable "handles" for RBAC assignments:  
    `spiffe://<env>://<namespace>/sa/<service-account>`

## Directory Structure
*   `database.tf`: Neon branch and database provisioning for both SPIRE and SpiceDB.
*   `k8_deployment.tf`: SPIRE Server + Registrar sidecar deployment.
*   `k8_daemonset.tf`: SPIRE Agent deployed to every node for local workload attestation.
*   `k8_config_map_*.tf`: Specialized configurations for Server, Agent, Registrar, and the Trust Bundle.
*   `k8_cluster_role*.tf` & `k8_service_accounts.tf`: RBAC and identities required for SPIRE to monitor the K8s API.

## Usage

```hcl
module "spire" {
  source          = "./modules/spire"
  
  environment     = "prod"
  neon_project_id = "your-neon-project-id"
  
  # Module automatically configures Kubernetes provider 
  # based on your cluster outputs.
}
