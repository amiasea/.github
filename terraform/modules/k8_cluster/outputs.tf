output "host" {
  description = "The Kubernetes API server endpoint (URL) used to communicate with the cluster."
  value       = azurerm_kubernetes_cluster.app_cluster.kube_config.0.host
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster."
  value       = azurerm_kubernetes_cluster.app_cluster.kube_config.0.client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the cluster."
  value       = azurerm_kubernetes_cluster.app_cluster.kube_config.0.client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used to verify the cluster's API server identity."
  value       = azurerm_kubernetes_cluster.app_cluster.kube_config.0.cluster_ca_certificate
  sensitive   = true
}