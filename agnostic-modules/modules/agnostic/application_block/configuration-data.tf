locals {

  aws_geographies = {
    "zuerich" = {
      primary = "eu-west-1" #HACK should be eu-central-1
    }
  }

  azure_geographies = {
    "zuerich" = {
      primary = "switzerlandnorth"
    }
  }

  aws_sections = {
    "app-group-alpha" = {
      subnet_name = "subnet-app1"
    }
    "app-group-beta" = {
      subnet_name = "subnet-app2-1"
    }
    "app-group-gamma" = {
      subnet_name = "subnet-app2-2"
    }
  }

  azure_sections = {
    "app-group-alpha" = {
      app_resource_group_name  = "rg-app1"
      vnet_resource_group_name = "rg-infra1"
      virtual_network_name     = "vnet-app1"
      subnet_name              = "subnet-app1"
    }
    "app-group-beta" = {
      app_resource_group_name  = "rg-app2"
      vnet_resource_group_name = "rg-infra2"
      virtual_network_name     = "vnet-app2"
      subnet_name              = "subnet-app2-1"
    }
    "app-group-gamma" = {
      app_resource_group_name  = "rg-app3"
      vnet_resource_group_name = "rg-app3" #HACK should be rg-infra2
      virtual_network_name     = "vnet-app2"
      subnet_name              = "subnet-app2-2"
    }
  }

  aws_vmimages = {
    "windows" = {
      "2019" = {
        #TODO
      }
    }
  }

  azure_vmimages = {
    "windows" = {
      "2019" = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter-smalldisk"
        version   = "latest"
      }
    }
  }
}
