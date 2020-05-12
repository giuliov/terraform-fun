### MAIN

terraform {
  required_version = "~> 0.12"

  backend "azurerm" {
    resource_group_name  = "pro-demo"
    storage_account_name = "terraformfun"
    container_name       = "terraform-state"
    key                  = "linux-vm-terraform.tfstate"
  }
}

provider "azurerm" {
  version = "~> 1.0"
}

provider "external" {
  version = "~> 1.0"
}

resource "azurerm_resource_group" "vm_demo" {
  name     = "tf-demo-${var.env_name}"
  location = var.resource_group_location

  tags = {
    environment = var.env_name
  }
}

# EOF

