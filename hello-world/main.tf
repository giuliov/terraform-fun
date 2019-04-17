### MAIN

resource "azurerm_resource_group" "hello_demo2" {
  name     = "${var.env_name}"
  location = "${var.resource_group_location}"

  tags {
    environment = "${var.env_name}"
  }
}

# EOF

