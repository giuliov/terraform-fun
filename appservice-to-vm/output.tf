### OUTPUTS

output "app_hostname" {
  value = "${azurerm_app_service.appsvcint_demo.default_site_hostname}"
}

output "publish_username" {
  value = "${azurerm_app_service.appsvcint_demo.site_credential.username}"
}

output "publish_password" {
  value = "${azurerm_app_service.appsvcint_demo.site_credential.password}"
}

# EOF

