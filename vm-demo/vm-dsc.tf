# VM Extensions

### DSC for application stack

resource "azurerm_virtual_machine_extension" "vm_demo_dsc" {
  name                       = "${var.env_name}-vm-dscext"
  virtual_machine_id         = azurerm_virtual_machine.vm_demo.id
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

  tags = {
    environment = var.env_name
  }
}

# EOF

