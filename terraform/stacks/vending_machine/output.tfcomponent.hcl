output "vpc_id" {
  description = "The ID of the provisioned VPC"
  type        = string
  value       = component.networking.vpc_id
}