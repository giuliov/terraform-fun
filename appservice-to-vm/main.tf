### MAIN

terraform {
  required_version = "~> 0.11.1"

  backend "azurerm" {
    resource_group_name  = "pro-demo"
    storage_account_name = "terraformfun"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = "~> 1.0"
}

provider "external" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 2.1"
}

provider "template" {
  version = "~> 2.1"
}

provider "random" {
  version = "~> 2.1"
}

resource "azurerm_resource_group" "appsvcint_demo" {
  name     = "${var.env_name}"
  location = "${var.resource_group_location}"

  tags {
    environment = "${var.env_name}"
  }
}

# EOF

