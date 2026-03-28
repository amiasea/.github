deployment "dev" {
  inputs = {
    project_name = "thor-test"
  }
}

# # This exports a value to the "Project" level
# publish_output "vpc_id" {
#   value = deployment.dev.network.vnet_id
# }

# store "stack_identity" "hcp" {
#   # This grabs the OIDC token from the HCP Stack run environment
#   identity_token = var.identity_token
# }