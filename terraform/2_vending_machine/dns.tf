# 1. Look up the existing Zone created by the Sovereign Ceremony
data "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = "rg-${var.prefix}" # The RG from your Sovereign setup
}

# 2. Create the record inside that existing Zone
resource "azurerm_dns_cname_record" "ui_env" {
  # Logic: "dev", "test", or "@" for prod
  name                = local.subdomain == "" ? "@" : trimsuffix(local.subdomain, ".")
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name
}

resource "azurerm_dns_cname_record" "ui_www" {
  # Logic: "www.dev" or "www" for prod
  name                = local.subdomain == "" ? "www" : "www.${trimsuffix(local.subdomain, ".")}"
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name
}