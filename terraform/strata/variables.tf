variable "organization_name" {
  type    = string
  default = "amiasea"
}

variable "azure_environment" {
  type = object({
    context = string
    landing_zones = object({
      institutive = string
      speculative = string
      prospective = string
      operative   = string
    })
    authority_principal = object({
      institutive = string
      speculative = string
      prospective = string
      operative   = string
    })
  })
}