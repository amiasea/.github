# resource "github_repository" "solution_ontologies" {
#     name = "solution-ontologies"
# }

# resource "github_repository" "tactical_delivery_packages" {
#     name = "tactical-delivery-packages"
# }

resource "github_repository" "iac_module_catalog" {
    name = "iac-module-catalog"
    auto_init = true
}

resource "github_repository_file" "iac_module_catalog_workflow" {
  depends_on = [github_repository.iac_module_catalog]

  repository = github_repository.iac_module_catalog.name
  file       = ".github/workflows/module_registration.yml"
  branch     = "main"
  overwrite_on_create = true

  content = <<-YAML
    name: Register Terraform Modules

    on:
      push:
        paths:
          - "terraform/modules/**"
      workflow_dispatch:

    permissions:
      contents: read
      id-token: write

    env:
      TF_ORGANIZATION: amiasea
      TF_PROVIDER: amiasea
      TF_API_URL: https://app.terraform.io/api/v2

    jobs:
      register-modules:
        runs-on: ubuntu-latest

        steps:
          - name: Check out repository
            uses: actions/checkout@v4

          - name: Log in to Azure
            uses: azure/login@v2
            with:
              client-id: $${{ vars.client_id }}
              tenant-id: $${{ vars.tenant_id }}
              subscription-id: $${{ vars.subscription_id }}

          - name: Retrieve Terraform token
            shell: bash
            env:
              KEY_VAULT_NAME: $${{ vars.key_vault_name }}
            run: |
              set -euo pipefail

              tf_token="$(
                az keyvault secret show \
                  --vault-name "$KEY_VAULT_NAME" \
                  --name "tf-token" \
                  --query value \
                  --output tsv
              )"

              if [[ -z "$tf_token" ]]; then
                echo "::error::Key Vault secret 'tf-token' is empty."
                exit 1
              fi

              echo "::add-mask::$tf_token"
              echo "TF_TOKEN=$tf_token" >> "$GITHUB_ENV"

          - name: Register modules
            shell: bash
            env:
              GITHUB_REPOSITORY: $${{ github.repository }}
              GITHUB_APP_INSTALLATION_ID: $${{ vars.installation_id }}
            run: |
              set -uo pipefail

              module_root="terraform/modules"

              if [[ ! -d "$module_root" ]]; then
                echo "No $module_root directory exists; nothing to register."
                exit 0
              fi

              register_module() {
                local module_dir="$1"
                local module_name
                local source_directory
                local tag_prefix
                local response_file
                local http_status
                local payload

                module_name="$(basename "$module_dir")"
                source_directory="$module_dir"
                tag_prefix="$${module_name}-v"
                response_file="$(mktemp)"

                echo "::group::Module: $module_name"

                if [[ ! -f "$module_dir/README.md" ]]; then
                  echo "::error file=$module_dir/README.md::Module '$module_name' has no README.md; skipping."
                  echo "::endgroup::"
                  rm -f "$response_file"
                  return 0
                fi

                echo "Checking whether '$module_name' is already registered..."

                http_status="$(
                  curl \
                    --silent \
                    --show-error \
                    --output "$response_file" \
                    --write-out "%%{http_code}" \
                    --request GET \
                    --header "Authorization: Bearer $TF_TOKEN" \
                    --header "Content-Type: application/vnd.api+json" \
                    "$TF_API_URL/organizations/$TF_ORGANIZATION/registry-modules/private/$TF_ORGANIZATION/$module_name/$TF_PROVIDER"
                )"

                case "$http_status" in
                  200)
                    echo "Already registered; skipping."
                    echo "::endgroup::"
                    rm -f "$response_file"
                    return 0
                    ;;

                  404)
                    echo "Not registered; creating VCS-backed module."
                    ;;

                  *)
                    echo "::error::Could not determine registration state for '$module_name' (HTTP $http_status)."
                    cat "$response_file"
                    echo "::endgroup::"
                    rm -f "$response_file"
                    return 0
                    ;;
                esac

                rm -f "$response_file"

                payload="$(
                  jq -n \
                    --arg name "$module_name" \
                    --arg provider "$TF_PROVIDER" \
                    --arg identifier "$GITHUB_REPOSITORY" \
                    --arg display_identifier "$GITHUB_REPOSITORY" \
                    --arg installation_id "$GITHUB_APP_INSTALLATION_ID" \
                    --arg source_directory "$source_directory" \
                    --arg tag_prefix "$tag_prefix" \
                    '{
                      data: {
                        type: "registry-modules",
                        attributes: {
                          name: $name,
                          provider: $provider,
                          vcs-repo: {
                            identifier: $identifier,
                            display_identifier: $display_identifier,
                            github-app-installation-id: $installation_id,
                            source-directory: $source_directory,
                            tag-prefix: $tag_prefix,
                            tags: true
                          }
                        }
                      }
                    }'
                )"

                response_file="$(mktemp)"

                http_status="$(
                  curl \
                    --silent \
                    --show-error \
                    --output "$response_file" \
                    --write-out "%%{http_code}" \
                    --request POST \
                    --header "Authorization: Bearer $TF_TOKEN" \
                    --header "Content-Type: application/vnd.api+json" \
                    --data "$payload" \
                    "$TF_API_URL/organizations/$TF_ORGANIZATION/registry-modules/vcs"
                )"

                case "$http_status" in
                  201)
                    echo "Registered successfully."
                    echo "  Repository:       $GITHUB_REPOSITORY"
                    echo "  Source directory: $source_directory"
                    echo "  Tag prefix:       $tag_prefix"
                    ;;

                  *)
                    echo "::error::Failed to register '$module_name' (HTTP $http_status)."
                    cat "$response_file"
                    ;;
                esac

                echo "::endgroup::"
                rm -f "$response_file"

                return 0
              }

              while IFS= read -r -d '' module_dir; do
                register_module "$module_dir"
              done < <(
                find "$module_root" \
                  -mindepth 1 \
                  -maxdepth 1 \
                  -type d \
                  -print0 |
                  sort -z
              )
  YAML
}

# resource "github_actions_variable" "iac_module_catalog_client_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "client_id"
#   value         = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.client_id

#   depends_on = [
#     github_repository.iac_module_catalog
#   ]
# }

# resource "github_actions_variable" "iac_module_catalog_tenant_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "tenant_id"
#   value         = var.azure_tenant_id

#   depends_on = [
#     github_repository.iac_module_catalog
#   ]
# }

# resource "github_actions_variable" "iac_module_catalog_subscription_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "subscription_id"
#   value         = var.azure_subscription_id

#   depends_on = [
#     github_repository.iac_module_catalog
#   ]
# }

# resource "github_actions_variable" "iac_module_catalog_key_vault_name" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "key_vault_name"
#   value         = var.key_vault_name

#   depends_on = [
#     github_repository.iac_module_catalog
#   ]
# }

# resource "github_actions_variable" "iac_module_catalog_installation_id" {
#   repository    = github_repository.iac_module_catalog.name
#   variable_name = "installation_id"
#   value         = data.tfe_github_app_installation.tfe_cloud_app.id

#   depends_on = [
#     github_repository.iac_module_catalog
#   ]
# }

# resource "github_actions_repository_oidc_subject_claim_customization_template" "iac_module_catalog" {
#   repository         = github_repository.iac_module_catalog.name
#   use_default        = false
#   include_claim_keys = ["repository_id", "workflow"]
# }

# resource "azurerm_federated_identity_credential" "iac_module_catalog" {
#   name                      = "github-iac-module-catalog-registration"
#   user_assigned_identity_id = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.id

#   issuer = "https://token.actions.githubusercontent.com"

#   subject = "repository_id:${github_repository.iac_module_catalog.repo_id}:workflow:module_registration.yml"

#   audience = ["api://AzureADTokenExchange"]

#   depends_on = [
#     github_actions_repository_oidc_subject_claim_customization_template.iac_module_catalog
#   ]
# }

resource "azapi_resource" "iac_module_catalog_federated_identity" {
  type      = "Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials@2025-05-31-preview"
  name      = "github-iac-module-catalog-registration"
  parent_id = azurerm_user_assigned_identity.uami_amiasea_stack_oidc.id

  body = {
    properties = {
      issuer = "https://token.actions.githubusercontent.com"

      audiences = [
        "api://AzureADTokenExchange"
      ]

      claimsMatchingExpression = {
        languageVersion = 1
        value           = "claims['sub'] matches 'organization:amiasea:project:amiasea:stack:sovereign:deployment:default:operation:*'"
      }
    }
  }

  depends_on = [
    github_repository.iac_module_catalog
  ]
}