resource "azurerm_dns_zone" "sovereign" {
  name                = var.domain
  resource_group_name = azurerm_resource_group.rg.name
}

# DNS RECORD: Environment Subdomains (Everything except Prod root)
resource "azurerm_dns_cname_record" "ui_env" {
  # This creates a record for every env in your list
  for_each = local.subdomains

  name                = each.value
  zone_name           = azurerm_dns_zone.sovereign.name
  resource_group_name = azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name

  provisioner "local-exec" {
    command = "until nslookup ${each.value}.${var.domain}; do sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}

# DNS RECORD: WWW CNAME (For all envs)
resource "azurerm_dns_cname_record" "ui_www" {
  for_each = local.subdomains

  name                = "www.${each.value}"
  zone_name           = azurerm_dns_zone.sovereign.name
  resource_group_name = azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  record              = azurerm_static_web_app.aviator_ui.default_host_name

  provisioner "local-exec" {
    command = "until nslookup www.${each.value}.${var.domain}; do echo 'Waiting for www DNS...'; sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}

# DNS RECORD: Root Alias A-Record (Only if 'prod' is in the list)
resource "azurerm_dns_a_record" "ui_root" {
  # Only creates this resource if "prod" exists in your env list
  count = contains(keys(local.subdomains), "prod") ? 1 : 0

  name                = "@"
  zone_name           = azurerm_dns_zone.sovereign.name
  resource_group_name = azurerm_dns_zone.sovereign.resource_group_name
  ttl                 = 300
  target_resource_id  = azurerm_static_web_app.aviator_ui.id

  provisioner "local-exec" {
    command = "until nslookup ${var.domain}; do echo 'Waiting for root DNS...'; sleep 5; done; echo 'DNS resolved, waiting 60s for SWA propagation...'; sleep 60"
  }
}
