output "host" {
  value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.host
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.cluster_ca_certificate
  sensitive = true
}

# output "client_certificate" {
#   value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.client_certificate
#   sensitive = true
# }

# output "client_key" {
#   value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.client_key
#   sensitive = true
# }

output "admin_token" {
  value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.password
  sensitive = true
}