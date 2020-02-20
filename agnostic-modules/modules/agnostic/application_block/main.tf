terraform {
  required_version = "~> 0.12"
}

locals {
  validate_arguments_platform    = (var.platform == "vm" && var.vm_platform != null) || (var.platform == "k8s" && var.k8s_platform != null) ? null : file("ERROR: Invalid platform argument.")
  validate_arguments_vm_platform = var.vm_platform != null && var.vm_platform.os == "windows" ? null : (var.vm_platform.os == "linux" ? null : file("ERROR: Invalid vm_platform argument."))
  # etc. etc. etc.
}


locals {
  vm_os_windows = var.vm_platform.os == "windows"
  vm_os_linux   = var.vm_platform.os == "linux"
  aws_section   = local.aws_sections[var.location.section]
  aws_vmimage   = local.aws_vmimages[var.vm_platform.os][var.vm_platform.os_version]
  azure_section = local.azure_sections[var.location.section]
  azure_vmimage = local.azure_vmimages[var.vm_platform.os][var.vm_platform.os_version]
}


module aws {
  source = "../../specific/aws/application_block/vm"
  # HACK until we get full support
  count_ = var.location.cloud == "aws" && var.platform == "vm" ? 1 : 0

  main_region         = local.aws_geographies[var.location.geographies[0]].primary
  subnet_name         = local.aws_section.subnet_name
  vm_name             = var.name
  vm_os_windows       = local.vm_os_windows
  vm_os_linux         = local.vm_os_linux
  vmimage_name_regex  = local.aws_vmimage.name_regex
  vmimage_name_filter = local.aws_vmimage.name_filter
  vmimage_owner       = local.aws_vmimage.owner
}

module azure {
  source = "../../specific/azure/application_block/vm"
  # HACK until we get full support
  count_ = var.location.cloud == "azure" && var.platform == "vm" ? 1 : 0

  location                            = local.azure_geographies[var.location.geographies[0]].primary
  resource_group_name                 = local.azure_section.app_resource_group_name
  virtual_network_resource_group_name = local.azure_section.vnet_resource_group_name
  virtual_network_name                = local.azure_section.virtual_network_name
  subnet_name                         = local.azure_section.subnet_name
  vm_name                             = var.name
  vm_os_windows                       = local.vm_os_windows
  vm_os_linux                         = local.vm_os_linux
  vm_os_image_publisher               = local.azure_vmimage.publisher
  vm_os_image_offer                   = local.azure_vmimage.offer
  vm_os_image_sku                     = local.azure_vmimage.sku
  vm_os_image_version                 = local.azure_vmimage.version
}