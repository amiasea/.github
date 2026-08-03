module "authentication" {
  source = "./authentication"

  tenant_id           = var.tenant_id
  subscription_id     = var.subscription_id
  location            = var.location
  resource_group_name = var.resource_group_name
}

module "secret_store" {
  source = "./secret_store"

  tenant_id           = var.tenant_id
  location            = var.location
  resource_group_name = var.resource_group_name

  key_vault_name = var.key_vault_name

  amiasea_tfe_org_token        = var.amiasea_tfe_org_token
  amiasea_github_app_private_key = var.amiasea_github_app_private_key
}

module "authorization" {
  source = "./authorization"

  sovereign_principal_id     = module.authentication.sovereign_principal_id
  sovereign_resource_group_id = module.authentication.sovereign_resource_group_id

  sovereign_key_vault_id = module.secret_store.key_vault_id
}