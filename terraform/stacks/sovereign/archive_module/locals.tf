locals {
  # This creates a map: {"prod": "aviator", "dev": "aviator-dev", ...}
  subdomains = {
    for e in var.environments : e => e == "prod" ? "aviator" : "aviator-${e}"
  }
}