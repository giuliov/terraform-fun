resource "azurerm_automation_account" "vm_demo" {
  name                = "${var.env_name}-automation"
  location            = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"

  sku {
    name = "Basic"
  }

  tags {
    environment = "${var.env_name}"
  }
}

resource "azurerm_automation_credential" "vsts_access_token" {
  name                = "${var.vsts_account}"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"
  account_name        = "${azurerm_automation_account.vm_demo.name}"
  username            = "giulio.dev@casavian.eu"
  password            = "${var.vsts_access_token}"
  description         = "VSTS PAT"
}

resource "azurerm_automation_credential" "vsts_service_account" {
  name                = "VstsAgentServiceAccount"
  resource_group_name = "${azurerm_resource_group.vm_demo.name}"
  account_name        = "${azurerm_automation_account.vm_demo.name}"
  username            = "${var.vstsagent_username}"
  password            = "${var.vstsagent_password}"
  description         = "VSTS Agent Service Account"
}
