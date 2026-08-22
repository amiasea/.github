variable "organization_name" {
  type    = string
  default = "amiasea"
}

variable "azure_environment" {
  type = object({
    context = string
    landing_zones = object({
      institutive = string
    })
    authority_principal = object({
      institutive = string
    })
  })
}

variable "tfc_azure_dynamic_credentials" {
  type = object({
    default = object({
      client_id_file_path  = string
      oidc_token_file_path = string
    })

    aliases = map(object({
      client_id_file_path  = string
      oidc_token_file_path = string
    }))
  })
}