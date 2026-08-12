# Azure

data "azurerm_billing_mca_account_scope" "amiasea" {
  billing_account_name = "e6f21f58-2e79-4634-a6bc-73667055877b:bbbb9159-b15e-4009-8cd8-73c88b42f6aa_2019-05-31"
  billing_profile_name = "MUGO-ML6Y-BG7-PGB"
  invoice_section_name = "V4EB-6NK3-PJA-PGB"
}