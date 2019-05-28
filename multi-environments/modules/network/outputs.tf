output "networks" {
  value = {
    shared      = { name = azurerm_virtual_network.network_module[0].name, id = azurerm_virtual_network.network_module[0].id }
    environment = var.env_type == "prod" ? { name = azurerm_virtual_network.network_module[0].name, id = azurerm_virtual_network.network_module[0].id } : { name = azurerm_virtual_network.network_module[1].name, id = azurerm_virtual_network.network_module[1].id }
  }
}
