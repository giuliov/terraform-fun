### VARIABLES

variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo-app2db"
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

# EOF #

