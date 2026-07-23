data "github_rest_api" "module_catalog" {
  endpoint = "repos/${var.module_catalog_repo_name}/contents/terraform/modules"
}

locals {
  modules = {
    for item in jsondecode(data.github_rest_api.module_catalog.body) :
    item.name => item.path
    if item.type == "dir"
  }
}

resource "tfe_registry_module" "private_modules" {
  for_each = local.modules

  organization   = "amiasea"
  module_provider = "amiasea"
  registry_name = "private"

  name         = each.key
  
  vcs_repo {
    display_identifier         = each.key
    identifier                 = var.module_catalog_repo_name
    github_app_installation_id = var.github_app_installation_id
    source_directory           = each.value
    tag_prefix                 = "${each.key}-v"
    tags                       = true
  }
}