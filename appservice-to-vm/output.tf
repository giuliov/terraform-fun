### OUTPUTS

output "vm_name" {
  value = "${azurerm_virtual_machine.appsvcint_demo.name}"
}

output "vm_internalip" {
  value = "${azurerm_network_interface.appsvcint_demo.private_ip_address}"
}

output "vm_publicip" {
  value = "${azurerm_public_ip.appsvcint_demo.ip_address}"
}

# EOF

