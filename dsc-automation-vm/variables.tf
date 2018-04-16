### VARIABLES

variable "admin_client_ip" {
  description = "Client IP of administrator"
}

variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo"
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

variable "vm_admin_password" {
  description = "Password for the Administrator account"
}

# EOF #

