variable "non_prod_vnet_range" {
  default = "10.40.0.0/16"
}

variable "env_map" {
  type = "map"

  # max 10 subnets per environment!
  default = {
    "null" = "0"
    "dev"  = "10"
    "qa"   = "20"
    "uat"  = "30"
  }
}

variable "env_name" {
  default = "dev"
}

variable "app_name" {
  default = "vp"
}

variable "fe_count" {
  default = 2
}

locals {
  env_base_index = "${ lookup( var.env_map, var.env_name) }"
}

resource "null_resource" "subnets" {
  triggers = {
    fe_cidr = "${ cidrsubnet(var.non_prod_vnet_range, 8, 3*local.env_base_index + 1) }"
    be_cidr = "${ cidrsubnet(var.non_prod_vnet_range, 8, 3*local.env_base_index + 2) }"
    db_cidr = "${ cidrsubnet(var.non_prod_vnet_range, 8, 3*local.env_base_index + 3) }"
  }
}

################################################################

resource "azurerm_resource_group" "non_prod" {
  name     = "non_prod"
  location = "westeurope"

  tags {
    environment = "shared"
    category    = "non-production"
  }
}

resource "azurerm_resource_group" "this_env" {
  name     = "${var.app_name}-${var.env_name}-env"
  location = "westeurope"

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_network" "non_prod" {
  name                = "non-prod-vnet"
  address_space       = ["${var.non_prod_vnet_range}"]
  location            = "${azurerm_resource_group.non_prod.location}"
  resource_group_name = "${azurerm_resource_group.non_prod.name}"
}

################################################################

resource "azurerm_subnet" "this_env" {
  name                 = "${var.app_name}-${var.env_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.non_prod.name}"
  virtual_network_name = "${azurerm_virtual_network.non_prod.name}"
  address_prefix       = "${null_resource.subnets.triggers.fe_cidr}"
}

resource "azurerm_network_interface" "this_env" {
  count               = "${var.fe_count}"
  name                = "${var.app_name}-${var.env_name}-fe-nic${1+count.index}"
  location            = "${azurerm_resource_group.this_env.location}"
  resource_group_name = "${azurerm_resource_group.this_env.name}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.this_env.id}"
    private_ip_address_allocation = "static"

    # +4 to avoid PrivateIPAddressInReservedRange error
    private_ip_address = "${cidrhost(null_resource.subnets.triggers.fe_cidr, 4+count.index)}"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_virtual_machine" "this_env" {
  count                 = "${var.fe_count}"
  name                  = "${var.app_name}-${var.env_name}-fe-vm${1+count.index}"
  location              = "${azurerm_resource_group.this_env.location}"
  resource_group_name   = "${azurerm_resource_group.this_env.name}"
  network_interface_ids = ["${ element(azurerm_network_interface.this_env.*.id, count.index) }"]
  vm_size               = "Standard_A0"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name = "${var.app_name}-${var.env_name}-fe${1+count.index}-osdisk"

    #vhd_uri       = "${azurerm_storage_account.this_env.primary_blob_endpoint}${azurerm_storage_container.this_env.name}/myosdisk1.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "${var.app_name}${var.env_name}fe${1+count.index}"
    admin_username = "envadmin"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags {
    environment = "${var.env_name}"
  }
}
