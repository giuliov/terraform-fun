terraform {
  required_version = "~> 0.12"
}

locals {
  validate_arguments_platform    = (var.platform == "vm" && var.vm_platform != null) || (var.platform == "k8s" && var.k8s_platform != null) ? null : file("ERROR: Invalid platform argument.")
  validate_arguments_vm_platform = var.vm_platform != null && var.vm_platform.os == "windows" ? null : file("ERROR: Invalid vm_platform argument.")
  # etc. etc. etc.
}


locals {
  # TODO from dedicated module
  azure_primary_location         = map("zuerich", "switzerlandnorth")[var.location.geographies[0]]
  azure_app_resource_group_name  = map("app-group-alpha", "rg-app1", "app-group-beta", "rg-app2", "app-group-gamma", "rg-app3")[var.location.section]
  azure_vnet_resource_group_name = map("app-group-alpha", "rg-app1", "app-group-beta", "rg-app2", "app-group-gamma", "rg-app3")[var.location.section]
  azure_virtual_network_name     = map("app-group-alpha", "vnet-app1", "app-group-beta", "vnet-app2", "app-group-gamma", "vnet-app2")[var.location.section]
  azure_subnet_name              = map("app-group-alpha", "subnet-app1", "app-group-beta", "subnet-app2-1", "app-group-gamma", "subnet-app2-2")[var.location.section]
  azure_vm_os_windows            = var.vm_platform.os == "windows"
  azure_vm_os_linux              = var.vm_platform.os == "linux"
  azure_vm_os_image_publisher    = map("windows", "MicrosoftWindowsServer")[var.vm_platform.os]
  azure_vm_os_image_offer        = map("windows", "WindowsServer")[var.vm_platform.os]
  azure_vm_os_image_sku          = map("2019", "2019-Datacenter-smalldisk")[var.vm_platform.os_version]
  azure_vm_os_image_version      = map("2019", "latest")[var.vm_platform.os_version]
}


module aws {
  source = "../../specific/aws/application_block/vm"
  # HACK until we get full support
  count_ = var.location.cloud == "aws" && var.platform == "vm" ? 1 : 0

  main_region = "eu-west-1" # TODO
  subnet_name = "subnet-app2-2"
  vm_name     = var.name
  /*
resource_group_name  = "rg-app3"
virtual_network_name = "vpc-app2"
  */
}

module azure {
  source = "../../specific/azure/application_block/vm"
  # HACK until we get full support
  count_                              = var.location.cloud == "azure" && var.platform == "vm" ? 1 : 0
  location                            = local.azure_primary_location
  resource_group_name                 = local.azure_app_resource_group_name
  virtual_network_resource_group_name = local.azure_vnet_resource_group_name
  virtual_network_name                = local.azure_virtual_network_name
  subnet_name                         = local.azure_subnet_name
  vm_name                             = var.name
  vm_os_windows                       = local.azure_vm_os_windows
  vm_os_linux                         = local.azure_vm_os_linux
  vm_os_image_publisher               = local.azure_vm_os_image_publisher
  vm_os_image_offer                   = local.azure_vm_os_image_offer
  vm_os_image_sku                     = local.azure_vm_os_image_sku
  vm_os_image_version                 = local.azure_vm_os_image_version

}