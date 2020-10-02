terraform {
  required_version = "~> 0.13"
}

# HACK
provider "aws" {
  alias  = "ie"
  region = "eu-west-1"
}

# HACK
provider "aws" {
  alias  = "gb"
  region = "eu-west-2"
}

provider azurerm {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true # good for demos, not for production
    }
  }
}
