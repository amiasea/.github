resource "azurerm_static_web_app" "aviator_ui" {
  provider            = azurerm.sub
  name                = "swa-${var.prefix}-ui-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "West US 2" # SWA is regional but serves globally
  sku_tier            = "Free"      # The magic words
}

# 1. Main Domain (e.g., dev.amiasea.com or amiasea.com)
resource "azurerm_static_web_app_custom_domain" "ui_main" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "${local.subdomain}${var.domain}"
  validation_type   = "cname-delegation"
}

# 2. WWW Subdomain (e.g., www.dev.amiasea.com or www.amiasea.com)
resource "azurerm_static_web_app_custom_domain" "ui_www" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "www.${local.subdomain}${var.domain}"
  validation_type   = "cname-delegation"
}