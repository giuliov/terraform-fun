module application_123 {
  source = "./modules/agnostic/application_block"

  scale = {
    performance     = 1
    security        = 3
    load            = 5
    confidentiality = 3
  }

  location = {
    cloud       = "aws"
    geographies = ["ireland"]
    section     = "app-group-gamma"
  }

  name = "app-123"

  platform = "vm"
  vm_platform = {
    os         = "linux"
    os_version = "ubuntu-18.04"
  }

  tags = {
    owner       = "john.doe@example.org"
    cost_center = "ABC123"
    # etc. etc.
  }
}
