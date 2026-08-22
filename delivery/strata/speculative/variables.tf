variable "location" {
  description = "The Azure location where Speculative capacity is established."
  type        = string
  default     = "centralus"
}

variable "environment_capacity" {
  description = "The declared number of Hosting and Collective environments established as Speculative capacity."
  type        = number
  default     = 2

  validation {
    condition     = var.environment_capacity >= 0
    error_message = "Hosting and Collective environments capacity must be zero or greater."
  }
}