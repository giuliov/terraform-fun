locals {

  aws_geographies = {
    "ireland" = {
      primary = "eu-west-1"
    }
    "england" = {
      primary = "eu-west-2"
    }
  }

  azure_geographies = {
    "ireland" = {
      primary   = "northeurope"
      secondary = "westeurope"
    }
    "england" = {
      primary = "uksouth"
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
      "server-2019" = {
        name_regex  = "^.*Windows.*"
        name_filter = "*Windows_Server-2019-English-Core-Base*"
        owner       = "801119661308" # Amazon
      }
    }
    "linux" = {
      "ubuntu-18.04" = {
        name_regex  = "^.*ubuntu.*"
        name_filter = "*ubuntu*18.04-amd64-server-*"
        owner       = "099720109477" # Canonical
      }
    }
  }

  azure_vmimages = {
    "windows" = {
      "server-2019" = {
        publisher = "MicrosoftWindowsServer"
        offer     = "WindowsServer"
        sku       = "2019-Datacenter-smalldisk"
        version   = "latest"
      }
    }
    "linux" = {
      "ubuntu-18-lts" = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
      }
      "ubuntu-18.04" = {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
      }
    }
  }

  aws_instance_types = [
    "t3.micro", # demo values
    "t3.micro", # demo values
    "t3.micro", # demo values
    "t3.micro",
    "t2.micro"
  ]

  azure_vm_sizes = [
    "Standard_D64s_v4",
    "Standard_D16s_v4",
    "Standard_D4s_v4",
    "Standard_DS2_v2",
    "Standard_B1ms"
  ]
}
