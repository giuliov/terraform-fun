### Front-End Research VM

resource "azurerm_network_interface" "vm_demo" {
  name                = "${var.env_name}-nic"
  location            = azurerm_resource_group.vm_demo.location
  resource_group_name = azurerm_resource_group.vm_demo.name

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.vm_demo.id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(azurerm_subnet.vm_demo.address_prefix, 5)
    public_ip_address_id          = azurerm_public_ip.vm_demo.id
  }

  tags = {
    environment = var.env_name
  }
}

data "azurerm_key_vault" "demo" {
  name                = "giuliov-pro-demo"
  resource_group_name = "pro-demo"
}

data "azurerm_key_vault_secret" "vm_demo_publickey" {
  name         = "vm-admin-publickey"
  key_vault_id = data.azurerm_key_vault.demo.id
}

resource "azurerm_virtual_machine" "vm_demo" {
  name                             = "${var.env_name}-vm"
  location                         = azurerm_resource_group.vm_demo.location
  resource_group_name              = azurerm_resource_group.vm_demo.name
  network_interface_ids            = [azurerm_network_interface.vm_demo.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true # CAVEAT: this is ok for demoing, a VERY BAD idea otherwise
  delete_data_disks_on_termination = true # CAVEAT: this is ok for demoing, a VERY BAD idea otherwise

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
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
    computer_name  = "tf-demovm"
    admin_username = var.vm_admin_username
    custom_data    = file("init-script.sh")
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.vm_admin_username}/.ssh/authorized_keys"
      key_data = data.azurerm_key_vault_secret.vm_demo_publickey.value
    }
  }

  tags = {
    environment = var.env_name
  }
}

# EOF

