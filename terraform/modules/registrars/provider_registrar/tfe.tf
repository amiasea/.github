# Dynamic PMR Shell Registry Entries
resource "tfe_registry_provider" "provider_shell" {
  for_each     = toset(var.provider_names)
  organization = var.tfe_org_name
  name         = each.key
}