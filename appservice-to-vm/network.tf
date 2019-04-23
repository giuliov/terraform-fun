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

resource "azurerm_public_ip" "appsvcint_demo_gw" {
  name                = "${var.env_name}-gw-publicip"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.env_name}-gw"

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

resource "azurerm_subnet" "appsvcint_demo_db" {
  name                 = "DB-Subnet"
  resource_group_name  = "${azurerm_resource_group.appsvcint_demo.name}"
  virtual_network_name = "${azurerm_virtual_network.appsvcint_demo.name}"
  address_prefix       = "${ cidrsubnet(azurerm_virtual_network.appsvcint_demo.address_space.0, 8, 22) }"
  service_endpoints    = ["Microsoft.Web"]
}

resource "azurerm_subnet" "appsvcint_demo_gw" {
  name                 = "GatewaySubnet"
  resource_group_name  = "${azurerm_resource_group.appsvcint_demo.name}"
  virtual_network_name = "${azurerm_virtual_network.appsvcint_demo.name}"
  address_prefix       = "${ cidrsubnet(azurerm_virtual_network.appsvcint_demo.address_space.0, 8, 4) }"
  service_endpoints    = ["Microsoft.Web"]
}

resource "azurerm_subnet_network_security_group_association" "appsvcint_demo_db" {
  subnet_id                 = "${azurerm_subnet.appsvcint_demo_db.id}"
  network_security_group_id = "${azurerm_network_security_group.appsvcint_demo.id}"
}

resource "azurerm_virtual_network_gateway" "appsvcint_demo" {
  name                = "${var.env_name}-vnetgw"
  location            = "${azurerm_resource_group.appsvcint_demo.location}"
  resource_group_name = "${azurerm_resource_group.appsvcint_demo.name}"
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "Basic"

  ip_configuration {
    public_ip_address_id = "${azurerm_public_ip.appsvcint_demo_gw.id}"
    subnet_id            = "${azurerm_subnet.appsvcint_demo_gw.id}"
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]
  }
}

# EOF

