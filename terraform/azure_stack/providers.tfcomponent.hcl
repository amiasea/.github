provider "azurerm" "dynamic_auth" {
  for_each = var.deployments # e.g., {"dev": "id-1", "prod": "id-2"}

  config {
    use_oidc        = true
    client_id       = each.value.client_id
    tenant_id       = each.value.tenant_id
    subscription_id = each.value.subscription_id
    # features {} ...
  }
}
