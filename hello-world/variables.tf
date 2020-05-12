### VARIABLES

# variable "azurerm_subscription_id" {}
# variable "azurerm_client_id" {}
# variable "azurerm_client_secret" {}
# variable "azurerm_tenant_id" {}

variable "env_name" {
  description = "Name of Environment"
  default     = "tf-demo-ldna"
}

variable "resource_group_location" {
  default = "westeurope"
}

# EOF #

