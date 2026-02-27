output "authority_workspace_id" {
  value       = tfe_workspace.authority.id
  description = "ID of the authority (ARM plane) workspace."
}

output "identity_workspace_id" {
  value       = tfe_workspace.identity.id
  description = "ID of the identity (Graph plane) workspace."
}