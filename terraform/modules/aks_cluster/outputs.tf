output "host" {
  value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.host
  sensitive = true
}

output "cluster_ca_certificate" {
  value     = azurerm_kubernetes_cluster.app_cluster.kube_config.0.cluster_ca_certificate
  sensitive = true
}