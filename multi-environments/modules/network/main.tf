resource "azurerm_resource_group" "network_module" {
  name     = "${var.env_name}-network"
  location = var.resource_group_location

  tags = {
    environment = var.env_name
  }
}

resource "azurerm_virtual_network" "network_module" {
  count               = local.number_of_vnets
  name                = "${var.env_name}-vnet-${count.index+1}"
  address_space       = ["10.${count.index + 10}.0.0/16"]
  location            = azurerm_resource_group.network_module.location
  resource_group_name = azurerm_resource_group.network_module.name

  tags = {
    environment = "${var.env_name}"
  }
}
