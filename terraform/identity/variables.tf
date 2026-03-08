variable "api_scope" {
  type        = string
  description = "Name of the API scope defined in the identity plane."
  default = "access_as_user"
}

variable "location" {
  type        = string
  description = "Azure region for all resources."
  default     = "centralus"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group to create and manage."
  default     = "rg-amiasea"
}

variable "amiasea_db_admins_group_id" {
  type        = string
  description = "Object ID of the Entra ID group that will be elevated to Cosmos DB Admins."
}