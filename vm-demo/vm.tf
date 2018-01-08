### Front-End Research VM

resource "azurerm_network_interface" "vm_demo" {
  name                = "${var.env_name}-nic"
  location            = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = "${azurerm_subnet.vm_demo.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "${ cidrhost(azurerm_subnet.vm_demo.address_prefix, 5) }"
    public_ip_address_id          = "${azurerm_public_ip.vm_demo.id}"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_machine" "vm_demo" {
  name                             = "${var.env_name}-vm"
  location                         = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name              = "${azurerm_resource_group.vm_demo.name}"
  network_interface_ids            = ["${azurerm_network_interface.vm_demo.id}"]
  vm_size                          = "Standard_B2s"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"

    #offer     = "WindowsServer"
    #sku       = "2016-Datacenter-Server-Core-smalldisk"
    offer = "WindowsServerSemiAnnual"

    sku     = "Datacenter-Core-1709-smalldisk"
    version = "latest"
  }

  storage_os_disk {
    name          = "${var.env_name}-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name          = "${var.env_name}-datadisk"
    create_option = "Empty"
    lun           = 0
    disk_size_gb  = "10"
  }

  os_profile {
    computer_name  = "${upper( var.env_name )}VM"
    admin_username = "${var.vm_admin_username}"
    admin_password = "${var.vm_admin_password}"
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = false
  }

  tags {
    environment = "${var.env_name}"
  }
}

# EOF

