# 1. Fetch the built-in Azure Policy Set (Initiative) Definition for K8s Baseline PSS
data "azurerm_policy_set_definition" "k8s_baseline" {
  display_name = "Kubernetes cluster pod security baseline standards for Linux-based workloads"
  provider = azurerm.scoped_sub
}

data "azurerm_resource_group" "target_rg" {
  provider = azurerm.scoped_sub 
  name = var.rg_name
}

# 2. Assign the policy at the Resource Group scope with custom namespace parameters
resource "azurerm_resource_group_policy_assignment" "aks_pss_baseline" {
  provider             = azurerm.scoped_sub 
  name                 = "aks-pss-baseline-${var.environment}"
  resource_group_id    = data.azurerm_resource_group.target_rg.id 
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

  depends_on = [
    # Reference the dynamic RBAC loop we set up in File 2
    azurerm_role_assignment.delegated_permissions_app_contributor 
  ]
}