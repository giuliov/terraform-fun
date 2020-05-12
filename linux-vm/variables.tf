### VARIABLES

variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo-ldna"
}

variable "resource_group_location" {
  default = "westeurope"
}

variable "vm_size" {
  default = "Standard_B2s"
}

variable "vm_admin_username" {
  description = "Username for the Administrator account"
  default     = "fancyname"
}

# EOF #

