### MAIN

resource "azurerm_resource_group" "arm_demo" {
  name     = "tf-demo-${var.env_name}"
  location = var.resource_group_location

  tags = {
    environment = var.env_name
  }
}

# EOF

