# Azure AKS App Cluster Module

A cost-optimized utility module for deploying lightweight **Azure Kubernetes Service (AKS)** clusters tailored for development and ephemeral environments.

### Why use this?
*   **Cost Efficiency:** Specifically configured with the "Free" SKU tier and B-Series burstable VMs to keep infrastructure costs at a minimum.
*   **Rapid Provisioning:** Uses Ephemeral OS disks for faster node boot times and improved I/O performance compared to persistent storage.
*   **Security by Default:** Implements System-Assigned Managed Identity, eliminating the need to manage service principal credentials manually.

## Usage

```hcl
module "aks_cluster" {
  source      = "app.terraform.io/your-org/aks-app-cluster/azurerm"
  version     = "1.0.0"

  environment = "dev"
  location    = "East US"
  rg_name     = "my-app-resource-group"
}

# The cluster is named 'app-dev-cluster' with a system node pool.
