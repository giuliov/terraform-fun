### VARIABLES

variable "powershell" {
  default     = "Powershell"
  description = "must be 'Powershell' or 'pwsh' depending on what you have installed"
}


variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo-app2db"
}

variable "resource_group_location" {
  default = "westeurope"
}

variable "vm_size" {
  default = "Standard_B2s"
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
  description = "Storage Container hosting extension scripts"
}

# EOF #
