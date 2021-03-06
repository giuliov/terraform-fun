### Front-End Research VM

resource "azurerm_network_interface" "appsvcint_demo" {
  name                = "${var.env_name}-db-nic"
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name

  ip_configuration {
    name                          = "ip-config"
    subnet_id                     = azurerm_subnet.appsvcint_demo_db.id
    private_ip_address_allocation = "static"
    private_ip_address            = cidrhost(azurerm_subnet.appsvcint_demo_db.address_prefix, 5)
    public_ip_address_id          = azurerm_public_ip.appsvcint_demo.id
  }

  tags = {
    environment = var.env_name
  }
}

resource "azurerm_virtual_machine" "appsvcint_demo" {
  name                             = "${var.env_name}-db-vm"
  location                         = azurerm_resource_group.appsvcint_demo.location
  resource_group_name              = azurerm_resource_group.appsvcint_demo.name
  network_interface_ids            = [azurerm_network_interface.appsvcint_demo.id]
  vm_size                          = var.vm_size
  delete_os_disk_on_termination    = true # CAVEAT: this is ok for demoing, a VERY BAD idea otherwise
  delete_data_disks_on_termination = true # CAVEAT: this is ok for demoing, a VERY BAD idea otherwise

  storage_image_reference {
    publisher = "MicrosoftSQLServer"
    offer     = "SQL2017-Ubuntu1604"
    sku       = "SQLDEV"
    version   = "latest"
  }

  storage_os_disk {
    name          = "${var.env_name}-db-osdisk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "terraform-sqldemo"
    admin_username = var.vm_admin_username
    admin_password = data.azurerm_key_vault_secret.appsvcint_demo_admin.value

    custom_data = <<EOF
MSSQL_SA_PASSWORD="${data.azurerm_key_vault_secret.appsvcint_demo_sa.value}" /opt/mssql/bin/mssql-conf set-sa-password 
systemctl start mssql-server
EOF

  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.env_name
  }
}

# EOF
