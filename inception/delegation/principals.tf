# Azure

resource "azurerm_user_assigned_identity" "uami_amiasea_automation_oidc" {
  name                = "uami-amiasea-automation-oidc"
  resource_group_name = var.sovereign_azure_resource_group_name
  location            = var.location
}

# AWS

# GCP