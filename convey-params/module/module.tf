################################################################

resource "azurerm_resource_group" "demo" {
  name     = "demo"
  location = "westeurope"
}

variable "non_prod_vnet_range" {
  default = "10.100.0.0/16"
}

resource "azurerm_virtual_network" "demo" {
  name                = "non-prod-vnet"
  address_space       = ["${var.non_prod_vnet_range}"]
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
}

resource "azurerm_subnet" "demo" {
  name                 = "demo-subnet"
  resource_group_name  = "${azurerm_resource_group.demo.name}"
  virtual_network_name = "${azurerm_virtual_network.demo.name}"
  address_prefix       = "${cidrsubnet(var.non_prod_vnet_range, 8, 1)}"
}

resource "azurerm_network_interface" "demo" {
  name                = "demo-fe-nic"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.demo.id}"
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_virtual_machine" "demo" {
  name                  = "demo-vm"
  location              = "${azurerm_resource_group.demo.location}"
  resource_group_name   = "${azurerm_resource_group.demo.name}"
  network_interface_ids = ["${azurerm_network_interface.demo.id}"]
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServerSemiAnnual"
    sku       = "Datacenter-Core-1709-smalldisk"
    version   = "latest"
  }

  storage_os_disk {
    name = "demo-vm-osdisk"

    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "demovm"
    admin_username = "demoadmin"
    admin_password = "Password1234!"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }
}

################################################################

variable "configurationArguments" {}

/*
data "template_file" "azurerm_virtual_machine_extension_demo_settings" {
  template = <<SETTINGS
    {
        "configuration": {
            "url"       : "https://terraformfun.blob.core.windows.net/vm-demo-scripts/DSCWebServer.zip",
            "script"    : "DSCWebServer.ps1",
            "function"  : "DSCWebServerConfig"
          },
          "configurationArguments": {
            $${configurationArguments}
          }
    }
SETTINGS

  vars {
    configurationArguments = "${var.configurationArguments}"
  }
}
*/

resource "azurerm_virtual_machine_extension" "demo" {
  name                       = "demo-vmext"
  location                   = "${azurerm_resource_group.demo.location}"
  resource_group_name        = "${azurerm_resource_group.demo.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.demo.name}"
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  #settings = "${data.template_file.azurerm_virtual_machine_extension_demo_settings.rendered}"
  settings = <<SETTINGS
    {
        "configuration": {
            "url"       : "https://terraformfun.blob.core.windows.net/vm-demo-scripts/DSCWebServer.zip",
            "script"    : "DSCWebServer.ps1",
            "function"  : "DSCWebServerConfig"
          },
          "configurationArguments": { ${var.configurationArguments} }
    }
SETTINGS
}
