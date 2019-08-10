### Front-End Security Group

# Trick to guarantee that we can access the target VM
data "external" "client_ip" {
  program = ["curl", "https://api.ipify.org/?format=json"]
}

resource "azurerm_network_security_group" "vm_demo" {
  name                = "${var.env_name}-sg"
  location            = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_http_in" {
  name                        = "${var.env_name}-http-in"
  priority                    = "200"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_subnet.vm_demo.address_prefix}"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_https_in" {
  name                        = "${var.env_name}-https-in"
  priority                    = "210"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "${azurerm_subnet.vm_demo.address_prefix}"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_rdp_in" {
  name                        = "${var.env_name}-rdp-in"
  priority                    = "230"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "${data.external.client_ip.result["ip"]}"
  destination_address_prefix  = "${azurerm_subnet.vm_demo.address_prefix}"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_any_out" {
  name                        = "${var.env_name}-any-out"
  priority                    = "300"
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "${azurerm_subnet.vm_demo.address_prefix}"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_webdeploy_in" {
  name                        = "${var.env_name}-webdeploy-in"
  priority                    = "240"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "8172"
  source_address_prefix       = "${data.external.client_ip.result["ip"]}"
  destination_address_prefix  = "${azurerm_subnet.vm_demo.address_prefix}"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

resource "azurerm_network_security_rule" "vm_demo_winrm_in" {
  name                        = "${var.env_name}-winrm-in"
  priority                    = "250"
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5985-5986"
  source_address_prefix       = "${data.external.client_ip.result["ip"]}"
  destination_address_prefix  = "${azurerm_subnet.vm_demo.address_prefix}"
  resource_group_name         = "${azurerm_resource_group.vm_demo.name}"
  network_security_group_name = "${azurerm_network_security_group.vm_demo.name}"
}

# EOF #

