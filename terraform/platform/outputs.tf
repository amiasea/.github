output "wip_name" {
  value       = hcp_iam_workload_identity_provider.wip.resource_name
  description = "Name of the workload identity provider created in HCP IAM."
}