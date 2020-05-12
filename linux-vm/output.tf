### OUTPUTS

output "vm_name" {
  value = azurerm_virtual_machine.vm_demo.name
}

output "vm_internalip" {
  value = azurerm_network_interface.vm_demo.private_ip_address
}

output "vm_publicip" {
  value = azurerm_public_ip.vm_demo.ip_address
}

output "vm_publicdns" {
  value = "${var.env_name}-direct.westeurope.cloudapp.azure.com"
}



# EOF

