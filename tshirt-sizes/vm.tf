### Front-End Research VM

locals {
  vm_demo-managed_disk-storage_account_type = {
    S = "Standard_LRS"
    M = "Standard_LRS"
    L = "Premium_LRS"
  }

  vm_demo-managed_disk-disk_size_gb = {
    S = "5"
    M = "20"
    L = "100"
  }

  vm_demo-virtual_machine-vm_size = {
    S = "Standard_B1s"
    M = "Standard_B4sm"
    L = "Standard_DS11_v2"
  }
}

resource "azurerm_network_interface" "vm_demo" {
  name                = "${var.env_name}-nic"
  location            = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = "${azurerm_subnet.vm_demo.id}"
    private_ip_address_allocation = "dynamic"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_managed_disk" "vm_demo" {
  name                 = "${var.env_name}-datadisk"
  location             = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name  = "${azurerm_resource_group.vm_demo.name}"
  storage_account_type = "${ lookup(local.vm_demo-managed_disk-storage_account_type, var.tshirt_size) }"
  create_option        = "Empty"
  disk_size_gb         = "${ lookup(local.vm_demo-managed_disk-disk_size_gb, var.tshirt_size) }"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_machine" "vm_demo" {
  name                             = "${var.env_name}-vm"
  location                         = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name              = "${azurerm_resource_group.vm_demo.name}"
  network_interface_ids            = ["${azurerm_network_interface.vm_demo.id}"]
  vm_size                          = "${ lookup(local.vm_demo-virtual_machine-vm_size, var.tshirt_size) }"
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"

    offer   = "WindowsServer"
    sku     = "2016-Datacenter-Server-Core-smalldisk"
    version = "latest"
  }

  storage_os_disk {
    name          = "${var.env_name}-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.vm_demo.name}"
    managed_disk_id = "${azurerm_managed_disk.vm_demo.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.vm_demo.disk_size_gb}"
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

