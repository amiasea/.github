output "dns_nameservers" {
  value = azurerm_dns_zone.sovereign.name_servers
}
