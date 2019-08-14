### Front-End Security Group

# Trick to guarantee that we can access the target VM
data "external" "client_ip" {
  program = ["curl", "https://api.ipify.org/?format=json"]
}

resource "azurerm_network_security_group" "appsvcint_demo" {
  name                = "${var.env_name}-sg"
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name
}

resource "azurerm_network_security_rule" "appsvcint_demo_ssh_in" {
  name                        = "${var.env_name}-ssh-in"
  priority                    = "200"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "${data.external.client_ip.result["ip"]}/32"
  destination_address_prefix  = azurerm_subnet.appsvcint_demo_db.address_prefix
  resource_group_name         = azurerm_resource_group.appsvcint_demo.name
  network_security_group_name = azurerm_network_security_group.appsvcint_demo.name
}

resource "azurerm_network_security_rule" "appsvcint_demo_tsql_in1" {
  name                        = "${var.env_name}-tsql-in1"
  priority                    = "210"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "VirtualNetwork"
  destination_address_prefix  = azurerm_subnet.appsvcint_demo_db.address_prefix
  resource_group_name         = azurerm_resource_group.appsvcint_demo.name
  network_security_group_name = azurerm_network_security_group.appsvcint_demo.name
}

resource "azurerm_network_security_rule" "appsvcint_demo_tsql_in2" {
  name                        = "${var.env_name}-tsql-in2"
  priority                    = "211"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "1433"
  source_address_prefix       = "${data.external.client_ip.result["ip"]}/32"
  destination_address_prefix  = azurerm_subnet.appsvcint_demo_db.address_prefix
  resource_group_name         = azurerm_resource_group.appsvcint_demo.name
  network_security_group_name = azurerm_network_security_group.appsvcint_demo.name
}

# EOF #
