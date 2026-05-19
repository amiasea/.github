# Main Domain Binding (e.g., amiasea.com or dev.amiasea.com)
resource "azurerm_static_web_app_custom_domain" "ui_main" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "${local.subdomain}.${var.domain}"
  
  # Root (Prod) MUST use dns-txt-token; Subdomains use cname-delegation
  validation_type   = var.env == "prod" ? "dns-txt-token" : "cname-delegation"
}

# WWW Subdomain Binding
resource "azurerm_static_web_app_custom_domain" "ui_www" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "www.${local.subdomain}.${var.domain}"
  validation_type   = "cname-delegation"
}