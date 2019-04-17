### NETWORKING

resource "azurerm_public_ip" "appsvcint_demo" {
  name                = "${var.env_name}-publicip"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.env_name}-direct"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_network" "appsvcint_demo" {
  name                = "${var.env_name}-net"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_subnet" "appsvcint_demo" {
  name                 = "${var.env_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.appsvcint_demo.name}"
  virtual_network_name = "${azurerm_virtual_network.appsvcint_demo.name}"
  address_prefix       = "${ cidrsubnet(azurerm_virtual_network.appsvcint_demo.address_space.0, 8, 22) }"
}

# EOF

