module "speculative" {
    source = "./speculative"

    azure_speculative_subscription_id = "bd0f2cca-0676-49e6-a8c2-cae21ea7216b"

    providers = {
      azurerm = azurerm.speculative
    }
}

data "azurerm_key_vault" "sovereign_kv" {
    name = "kv-amiasea-sovereign"
    resource_group_name = "rg-amiasea-sovereign"
}

ephemeral "azurerm_key_vault_secret" "amiasea_github_app_private_key" {
  name         = "amiasea-github-app-private-key"
  key_vault_id = data.azurerm_key_vault.sovereign_kv.id

  depends_on = [ azurerm_key_vault_secret.amiasea_tfe_org_token ]
}