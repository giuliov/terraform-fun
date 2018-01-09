# VM Extensions

### DSC for application stack

resource "azurerm_virtual_machine_extension" "vm_demo_dsc" {
  name                       = "${var.env_name}-vm-dscext"
  location                   = "${azurerm_resource_group.vm_demo.location}"
  resource_group_name        = "${azurerm_resource_group.vm_demo.name}"
  virtual_machine_name       = "${azurerm_virtual_machine.vm_demo.name}"
  publisher                  = "Microsoft.Powershell"
  type                       = "DSC"
  type_handler_version       = "2.73"
  auto_upgrade_minor_version = true

  #${azurerm_storage_blob.vm_demodsc_package.url}
  settings = <<SETTINGS
    {
        "configuration": {
            "url"       : "https://terraformfun.blob.core.windows.net/vm-demo-scripts/DSCWebServer.zip",
            "script"    : "DSCWebServer.ps1",
            "function"  : "DSCWebServerConfig"
          },
          "configurationArguments": {
            "IISWebSite"  : "Default Web Site",
            "FQDNs"       : "${azurerm_public_ip.vm_demo.fqdn},${var.env_name}.${var.dns_domain}"
          }
    }
SETTINGS

  tags {
    environment = "${var.env_name}"
  }
}

# EOF

