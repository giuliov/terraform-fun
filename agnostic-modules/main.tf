module application_123_aws {
  source = "./modules/agnostic/application_block"

  quality_of_service = {
    performance     = 1
    security        = 3
    load            = 5
    confidentiality = 3
  }

  location = {
    cloud     = "aws"
    geography = "ireland"
    section   = "app-group-gamma"
  }

  name = "app-123-win"

  platform = "vm"
  vm_platform = {
    os         = "windows"
    os_version = "server-2019"
  }

  tags = {
    owner       = "john.doe@example.org"
    cost_center = "ABC123"
  }
}



module application_123_azure {
  source = "./modules/agnostic/application_block"

  quality_of_service = {
    performance     = 1
    security        = 3
    load            = 5
    confidentiality = 3
  }

  location = {
    cloud     = "azure"
    geography = "ireland"
    section   = "app-group-gamma"
  }

  name = "app-123-linux"

  platform = "vm"
  vm_platform = {
    os         = "linux"
    os_version = "ubuntu-18.04"
  }

  tags = {
    owner       = "john.doe@example.org"
    cost_center = "ABC123"
  }
}
