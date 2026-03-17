locals {
  # This uses a 'for' loop to find the one where the display_name is an exact match
  target_sub_id = [
    for s in data.azurerm_subscriptions.search.subscriptions : 
    s.subscription_id if s.display_name == "${var.prefix}-${var.env}"
  ][0]

  subdomain = var.env == "prod" ? "aviator" : "aviator-${var.env}."
}