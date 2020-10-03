terraform {
  required_version = "~> 0.13"
}

provider "aws" {
  region = local.aws_geographies[var.location.geography].primary
}

provider "aws" {
  alias = "primary"
  region = local.aws_geographies[var.location.geography].primary
}

provider "aws" {
  alias = "secondary"
  region = local.aws_geographies[var.location.geography].secondary
}

provider azurerm {
  features {
    virtual_machine {
      delete_os_disk_on_deletion = true # good for demos, not for production
    }
  }
}
