module application_123_aws {
  source = "./modules/agnostic/application_block"

  quality_of_service = {
    performance     = 5
    security        = 3 # not used
    load            = 5 # not used
    confidentiality = 3 # not used
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


module application_124_aws {
  source = "./modules/agnostic/application_block"

  quality_of_service = {
    performance     = 4
    security        = 3 # not used
    load            = 5 # not used
    confidentiality = 3 # not used
  }

  location = {
    cloud     = "aws"
    geography = "england"
    section   = "app-group-gamma"
  }

  name = "app-124-linux"

  platform = "vm"
  vm_platform = {
    os         = "linux"
    os_version = "ubuntu-18.04"
  }

  tags = {
    owner       = "john.doe@example.org"
    cost_center = "ABC124"
  }
}



module application_123_azure {
  source = "./modules/agnostic/application_block"

  quality_of_service = {
    performance     = 2
    security        = 3 # not used
    load            = 5 # not used
    confidentiality = 3 # not used
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
