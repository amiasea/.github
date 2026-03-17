# Look up the existing Zone created by the Sovereign Ceremony
data "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = "rg-${var.prefix}" # The RG from your Sovereign setup
}

# DNS RECORD: Subdomain CNAME (Dev/Test only)
resource "azurerm_dns_cname_record" "ui_env" {
  count               = var.env == "prod" ? 0 : 1
  name                = trimsuffix(local.subdomain, ".")
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name
}

# DNS RECORD: WWW CNAME (All envs)
resource "azurerm_dns_cname_record" "ui_www" {
  name                = var.env == "prod" ? "www" : "www.${trimsuffix(local.subdomain, ".")}"
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name
}

# DNS RECORD: Root Alias A-Record (Prod only)
resource "azurerm_dns_a_record" "ui_root" {
  count               = var.env == "prod" ? 1 : 0
  name                = "@"
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_static_web_app.aviator_ui.id # Alias to SWA
}

# Main Domain Binding (e.g., amiasea.com or dev.amiasea.com)
resource "azurerm_static_web_app_custom_domain" "ui_main" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "${local.subdomain}${var.domain}"
  
  # Root (Prod) MUST use dns-txt-token; Subdomains use cname-delegation
  validation_type   = var.env == "prod" ? "dns-txt-token" : "cname-delegation"

  depends_on = [
    azurerm_dns_cname_record.ui_env, 
    azurerm_dns_a_record.ui_root
  ]
}

# WWW Subdomain Binding
resource "azurerm_static_web_app_custom_domain" "ui_www" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "www.${local.subdomain}${var.domain}"
  validation_type   = "cname-delegation"

  depends_on = [azurerm_dns_cname_record.ui_www]
}