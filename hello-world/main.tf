### MAIN

terraform {
  required_version = "~> 0.11.1"
}

provider "azurerm" {
  version         = "~> 1.0"
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

