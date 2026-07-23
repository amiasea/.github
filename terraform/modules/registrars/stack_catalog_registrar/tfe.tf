resource "tfe_stack" "stacks" {
  for_each    = var.stack_names
  
  name        = each.value
  project_id  = var.tfe_project_id
  description = "CI Stack for custom module: ${each.value}"
  
  vcs_repo {
    identifier      = "amiasea/iac-stack-catalog"
    branch          = "main"
    
    github_app_installation_id = var.github_app_installation_id
  }

  # --- PATCH WORKAROUND ---
  # Replace this when the tfe provider supports the working_directory attribute for stacks and remove the TFE PAT token
  # https://github.com/hashicorp/terraform-provider-tfe/issues/2027
  provisioner "local-exec" {

    command = <<EOT
      curl \
        --request PATCH \
        --header "Authorization: Bearer ${var.tfe_pat}" \
        --header "Content-Type: application/vnd.api+json" \
        --data '{
          "data": {
            "id": "${self.id}",
            "type": "stacks",
            "attributes": {
              "vcs-repo": {
                "identifier": "amiasea/iac-stack-catalog",
                "github-app-installation-id": "${var.github_app_installation_id}",
                "working-directory": "terraform/stacks/${each.key}",
                "trigger-patterns": [
                  "terraform/stacks/${each.key}/**/*"
                ]
              }
            }
          }
        }' \
        https://app.terraform.io/api/v2/stacks/${self.id}
    EOT
  }
}