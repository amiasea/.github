locals {
  subdomain = var.env == "prod" ? "" : "${var.env}"
}