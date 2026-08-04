# Azure

# resource "github_actions_variable" "iac_module_catalog_azure_client_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "AZURE_CLIENT_ID"
#   value         = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.client_id
# }

# resource "github_actions_variable" "iac_module_catalog_azure_tenant_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "AZURE_TENANT_ID"
#   value         = var.authority_azure_tenant_id
# }

# resource "github_actions_variable" "iac_module_catalog_azure_subscription_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "AZURE_SUBSCRIPTION_ID"
#   value         = var.sovereign_azure_subscription_id
# }

# AWS

# GCP