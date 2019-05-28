terraform {
  required_version = "~> 0.12"

  backend "azurerm" {
    resource_group_name  = "pro-demo"
    storage_account_name = "terraformfun"
    container_name       = "terraform-state"
    key                  = "multi-env-prod.tfstate"
  }
}
