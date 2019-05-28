variable "env_type" {
  description = "Type of Environment (prod or dev)"
}

variable "env_name" {
  description = "Name of Environment (max 8 chars)"
  default     = "demo"
}

variable "resource_group_location" {
  default = "westeurope"
}
