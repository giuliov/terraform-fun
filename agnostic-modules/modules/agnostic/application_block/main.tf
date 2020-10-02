locals {
  aws_main_region = local.aws_geographies[var.location.geography].primary
  vm_os_windows   = var.vm_platform.os == "windows"
  vm_os_linux     = var.vm_platform.os == "linux"
  aws_section     = local.aws_sections[var.location.section]
  aws_vmimage     = local.aws_vmimages[var.vm_platform.os][var.vm_platform.os_version]
  aws_vmperf      = local.aws_instance_types[var.quality_of_service.performance - 1]
  azure_section   = local.azure_sections[var.location.section]
  azure_vmimage   = local.azure_vmimages[var.vm_platform.os][var.vm_platform.os_version]
  azure_vmperf    = local.azure_vm_sizes[var.quality_of_service.performance - 1]
}


module aws_ie {
  source = "../../specific/aws/application_block/vm"
  count  = var.location.cloud == "aws" && var.platform == "vm" && var.location.geography == "ireland" ? 1 : 0

  main_region      = local.aws_main_region
  subnet_name      = local.aws_section.subnet_name
  vm_name          = var.name
  vm_os_windows    = local.vm_os_windows
  vm_os_linux      = local.vm_os_linux
  vm_os_image_spec = local.aws_vmimage
  vm_perf_class    = local.aws_vmperf
  tags             = var.tags

  providers = {
    # HACK
    aws = aws.ie
  }
}


module aws_gb {
  source = "../../specific/aws/application_block/vm"
  count  = var.location.cloud == "aws" && var.platform == "vm" && var.location.geography == "england" ? 1 : 0

  main_region      = local.aws_main_region
  subnet_name      = local.aws_section.subnet_name
  vm_name          = var.name
  vm_os_windows    = local.vm_os_windows
  vm_os_linux      = local.vm_os_linux
  vm_os_image_spec = local.aws_vmimage
  vm_perf_class    = local.aws_vmperf
  tags             = var.tags

  providers = {
    # HACK
    aws = aws.gb
  }
}


module azure {
  source = "../../specific/azure/application_block/vm"
  count  = var.location.cloud == "azure" && var.platform == "vm" ? 1 : 0

  location                            = local.azure_geographies[var.location.geography].primary
  resource_group_name                 = local.azure_section.app_resource_group_name
  virtual_network_resource_group_name = local.azure_section.vnet_resource_group_name
  virtual_network_name                = local.azure_section.virtual_network_name
  subnet_name                         = local.azure_section.subnet_name
  vm_name                             = var.name
  vm_os_windows                       = local.vm_os_windows
  vm_os_linux                         = local.vm_os_linux
  vm_os_image_spec                    = local.azure_vmimage
  vm_perf_class                       = local.azure_vmperf
  tags                                = var.tags

  providers = {}
}