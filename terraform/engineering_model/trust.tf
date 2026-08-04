data "github_organization" "gh_org" {
  name = "amiasea"
}

resource "azurerm_federated_identity_credential" "iac_module_catalog_github_actions_credential" {
  name                      = "iac-module-catalog-github-actions-credential"
  user_assigned_identity_id = azurerm_user_assigned_identity.uami_amiasea_automation_oidc.id

  issuer   = "https://token.actions.githubusercontent.com"
  subject  = "repo:${data.github_organization.gh_org.name}@${data.github_organization.gh_org.id}/${github_repository.iac_module_catalog.name}@${github_repository.iac_module_catalog.repo_id}:ref:refs/heads/main"
  audience = ["api://AzureADTokenExchange"]
}