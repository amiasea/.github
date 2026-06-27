resource "azurerm_storage_account" "st" {
  name                     = "st${var.prefix}${var.env}" # Note: max 24 chars, alphanumeric
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_queue" "events" {
  name                 = "clipboard-actions"
  storage_account_name = azurerm_storage_account.st.name
}

# The Service Plan for the Reconciler (referenced in your HCL)
resource "azurerm_service_plan" "asp" {
  name                = "asp-${var.prefix}-reconciler-${var.env}"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1" # Consumption
}