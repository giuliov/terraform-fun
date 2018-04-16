### MAIN

terraform {
  required_version = ">= 0.11.7"

  backend "azurerm" {
    resource_group_name  = "pro-demo"
    storage_account_name = "terraformfun"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  version         = "~> 1.3.2"
  subscription_id = "${var.azurerm_subscription_id}"
  client_id       = "${var.azurerm_client_id}"
  client_secret   = "${var.azurerm_client_secret}"
  tenant_id       = "${var.azurerm_tenant_id}"
}

resource "azurerm_resource_group" "vm_demo" {
  name     = "${var.env_name}"
  location = "${var.resource_group_location}"

  tags {
    environment = "${var.env_name}"
  }
}

# EOF

