resource "azurerm_static_web_app" "aviator_ui" {
  provider            = azurerm.sub
  name                = "swa-${var.prefix}-ui-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = "West US 2" # SWA is regional but serves globally
  sku_tier            = "Free"      # The magic words
}

resource "azurerm_static_web_app_custom_domain" "ui_main" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "${local.subdomain}${var.domain}"
  
  # Logic: Use TXT for root (prod), CNAME for subdomains (dev/test)
  validation_type   = local.subdomain == "" ? "dns-txt-token" : "cname-delegation"

  depends_on = [azurerm_dns_cname_record.ui_env]
}

resource "azurerm_static_web_app_custom_domain" "ui_www" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "www.${local.subdomain}${var.domain}"
  validation_type   = "cname-delegation"

  depends_on = [azurerm_dns_cname_record.ui_www]
}