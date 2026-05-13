# 1. Fetch the built-in Azure Policy Set (Initiative) Definition for K8s Baseline PSS
data "azurerm_policy_set_definition" "k8s_baseline" {
  display_name = "Kubernetes cluster pod security baseline standards for Linux-based workloads"
}

# 2. Assign the policy at the Resource Group scope with custom namespace parameters
resource "azurerm_resource_group_policy_assignment" "aks_pss_baseline" {
  name                 = "aks-pss-baseline-${var.environment}"
  resource_group_id    = var.rg_name # Or use data.azurerm_resource_group.rg.id if available
  policy_definition_id = data.azurerm_policy_set_definition.k8s_baseline.id
  display_name         = "AKS Pod Security Baseline Standards (${var.environment})"
  description          = "Enforces standard K8s pod baseline profiles while exempting infrastructure layers like SPIRE."

  # Required to ensure Azure processes parameters and effects
  enforce = true

  # Inject HCL map and encode it to JSON to pass target parameters to Azure Policy
  parameters = jsonencode({
    effect = {
      value = "Deny"
    }
    excludedNamespaces = {
      value = ["kube-system", "gatekeeper-system", "spire"]
    }
  })
}