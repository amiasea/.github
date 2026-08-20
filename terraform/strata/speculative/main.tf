
resource "azurerm_resource_group" "hosting_environment" {
    for_each = toset([
    for i in range(var.environment_capacity) :
    "hosting-${i + 1}"
  ])

  name      = each.value
  location  = var.location
}

resource "azurerm_resource_group" "collective_environment" {
    for_each = toset([
    for i in range(var.environment_capacity) :
    "collective-${i + 1}"
  ])

  name      = each.value
  location  = var.location
}