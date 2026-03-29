output "secret_value" {
    value = data.azurerm_key_vault_secret.whisper_genie.value
    ephemeral = true
}