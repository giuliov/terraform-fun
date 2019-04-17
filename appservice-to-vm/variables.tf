### VARIABLES

variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo-ldna"
}

variable "resource_group_location" {
  default = "westeurope"
}

variable "dns_domain" {
  description = "DNS domain"
}

variable "vm_admin_username" {
  description = "Username for the Administrator account"
  default     = "fancyname"
}

variable "scripts_resource_group_name" {
  description = "Resource Group hosting extension scripts"
}

variable "scripts_storage_account_name" {
  description = "Storage Account hosting extension scripts"
}

variable "scripts_storage_container_name" {
  description = "Container hosting extension scripts"
}

# EOF #

