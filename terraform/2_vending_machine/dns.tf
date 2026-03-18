# Look up the existing Zone created by the Sovereign Ceremony
data "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = "rg-${var.prefix}" # The RG from your Sovereign setup
}

# DNS RECORD: Subdomain CNAME (Dev/Test only)
resource "azurerm_dns_cname_record" "ui_env" {
  count               = var.env == "prod" ? 0 : 1
  name                = local.subdomain
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name

    # This "loops" until nslookup actually finds the record
  provisioner "local-exec" {
    command = "until nslookup ${local.subdomain}.${var.domain}; do sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}

# DNS RECORD: WWW CNAME (All envs)
resource "azurerm_dns_cname_record" "ui_www" {
  # Changed: Always use www.${local.subdomain} to match your intended URL
  name                = "www.${local.subdomain}" 
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name

  provisioner "local-exec" {
    # Match the name here too
    command = "until nslookup www.${local.subdomain}.${var.domain}; do echo 'Waiting for www DNS...'; sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}

# DNS RECORD: Root Alias A-Record (Prod only)
resource "azurerm_dns_a_record" "ui_root" {
  count               = var.env == "prod" ? 1 : 0
  name                = "@"
  zone_name           = data.azurerm_dns_zone.sovereign.name
  resource_group_name = data.azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_static_web_app.aviator_ui.id # Alias to SWA

  # For the root, we check the naked domain (e.g., amiasea.com)
  provisioner "local-exec" {
    command = "until nslookup ${var.domain}; do echo 'Waiting for root DNS...'; sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}

# Main Domain Binding (e.g., amiasea.com or dev.amiasea.com)
resource "azurerm_static_web_app_custom_domain" "ui_main" {
  static_web_app_id = azurerm_static_web_app.aviator_ui.id
  domain_name       = "${local.subdomain}.${var.domain}"
  
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
  domain_name       = "www.${local.subdomain}.${var.domain}"
  validation_type   = "cname-delegation"

  depends_on = [azurerm_dns_cname_record.ui_www]
}