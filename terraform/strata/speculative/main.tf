resource "azapi_resource" "hosting_environment" {
  for_each = toset([
    for i in range(var.environment_capacity) :
    "hosting-${i + 1}"
  ])

  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  name      = each.value
  location  = var.location
  parent_id = var.azure_speculative_subscription_id
}

resource "azapi_resource" "collective_environment" {
  for_each = toset([
    for i in range(var.environment_capacity) :
    "collective-${i + 1}"
  ])

  type      = "Microsoft.Resources/resourceGroups@2025-04-01"
  name      = each.value
  location  = var.location
  parent_id = var.azure_speculative_subscription_id
}
