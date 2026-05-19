locals {
  subdomain = var.env == "prod" ? "aviator" : "aviator-${var.env}"
}