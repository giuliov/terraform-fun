data azurerm_resource_group rg {
  name = var.resource_group_name
}

data azurerm_subnet app_subnet {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.virtual_network_resource_group_name
}


locals {
  # TODO
  admin_username = "vmadmin"
  admin_password = "P@ssw0rd!"
}


resource azurerm_network_interface default_nic {
  name                = "${var.vm_name}-nic"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  ip_configuration {
    name      = "ip-config"
    subnet_id = data.azurerm_subnet.app_subnet.id
    # TODO
    private_ip_address_allocation = "dynamic"
  }
  tags = var.tags
}

resource azurerm_virtual_machine vm {
  name                  = "${var.vm_name}-vm"
  resource_group_name   = data.azurerm_resource_group.rg.name
  location              = data.azurerm_resource_group.rg.location
  network_interface_ids = [azurerm_network_interface.default_nic.id]
  vm_size               = var.vm_perf_class

  storage_image_reference {
    publisher = var.vm_os_image_spec.publisher
    offer     = var.vm_os_image_spec.offer
    sku       = var.vm_os_image_spec.sku
    version   = var.vm_os_image_spec.version
  }

  storage_os_disk {
    name          = "${var.vm_name}-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  # only for demoing!
  delete_os_disk_on_termination = true

  os_profile {
    computer_name  = var.vm_os_windows ? substr(upper(var.vm_name), 0, 15) : var.vm_name
    admin_username = local.admin_username
    admin_password = local.admin_password
  }

  dynamic "os_profile_windows_config" {
    for_each = var.vm_os_windows ? ["dummy"] : []
    content {
      provision_vm_agent        = true
      enable_automatic_upgrades = false
    }
  }
  dynamic "os_profile_linux_config" {
    for_each = var.vm_os_linux ? ["dummy"] : []
    content {
      disable_password_authentication = false
    }
  }

  tags = merge({
    Env    = lower(terraform.workspace)
    OSType = var.vm_os_windows ? "windows" : "linux"
    },
  var.tags)
}