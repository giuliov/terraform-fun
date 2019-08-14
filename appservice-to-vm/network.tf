### NETWORKING

resource "azurerm_public_ip" "appsvcint_demo" {
  name                = "${var.env_name}-appsvc-publicip"
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name
  allocation_method   = "Static"
  domain_name_label   = "${var.env_name}-appsvc"

  tags = {
    environment = var.env_name
  }
}

resource "azurerm_public_ip" "appsvcint_demo_gw" {
  name                = "${var.env_name}-gw-publicip"
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name
  allocation_method   = "Dynamic"
  domain_name_label   = "${var.env_name}-gw"

  tags = {
    environment = var.env_name
  }
}

resource "azurerm_virtual_network" "appsvcint_demo" {
  name                = "${var.env_name}-app-net"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name

  tags = {
    environment = var.env_name
  }
}

resource "azurerm_subnet" "appsvcint_demo_db" {
  name                 = "DB-Subnet"
  resource_group_name  = azurerm_resource_group.appsvcint_demo.name
  virtual_network_name = azurerm_virtual_network.appsvcint_demo.name
  address_prefix       = cidrsubnet(azurerm_virtual_network.appsvcint_demo.address_space[0], 8, 22, )
}

resource "azurerm_subnet" "appsvcint_demo_gw" {
  # name must be GatewaySubnet
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.appsvcint_demo.name
  virtual_network_name = azurerm_virtual_network.appsvcint_demo.name
  address_prefix = cidrsubnet(
    azurerm_virtual_network.appsvcint_demo.address_space[0],
    8,
    4,
  )
}

resource "azurerm_subnet_network_security_group_association" "appsvcint_demo_db" {
  subnet_id                 = azurerm_subnet.appsvcint_demo_db.id
  network_security_group_id = azurerm_network_security_group.appsvcint_demo.id
}

resource "azurerm_virtual_network_gateway" "appsvcint_demo" {
  name                = "${var.env_name}-vnetgw"
  location            = azurerm_resource_group.appsvcint_demo.location
  resource_group_name = azurerm_resource_group.appsvcint_demo.name
  type                = "Vpn"
  vpn_type            = "RouteBased"
  sku                 = "Basic"

  ip_configuration {
    public_ip_address_id = azurerm_public_ip.appsvcint_demo_gw.id
    subnet_id            = azurerm_subnet.appsvcint_demo_gw.id
  }

  vpn_client_configuration {
    address_space = ["172.16.0.0/24"]

    root_certificate {
      name             = "AppServiceCertificate.cer"
      public_cert_data = "MIIDPjCCAiqgAwIBAgIQUUz5qfwBGKdMQjtiRe2mSjAJBgUrDgMCHQUAMC0xKzApBgNVBAMTIldlYnNpdGVzQ2VydGlmaWNhdGVhcHAyZGItZGVtby1uZXQwHhcNMTkwNDI0MDYxNjI4WhcNMzkxMjMxMjM1OTU5WjAtMSswKQYDVQQDEyJXZWJzaXRlc0NlcnRpZmljYXRlYXBwMmRiLWRlbW8tbmV0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsAEzlwHXMyKjcrJ+wmfYXAdeMBw5TnmDO1+0ETyJBGlUXOvmqlIqFl24QQi6gONWB1JkS0morzaY9ZS6ST5S+2ois/SgkN11DHAjJLQ/1ZhRVPDTbdI+lOwIYy1/bPOSJdKnkPYIEi8/0lpmrAiC/8AXqL7d+lTxD5zhwQNARdQCTOb9gDg+EXv38IMSESiMJ0VScGcI3zIbcINEjIvOy3cPPU/AO5oxtNhu2U8wSyEAKhiO7K2RUxJ1zt4OFKSUf3jLfZ5mFuvZsqhIVY/2edSwMGowBDaLeGxmnB5qvAVI6QJEPEIaa/f2g4dNJU5aYRGQOxyF9OoSx05eZcALLQIDAQABo2IwYDBeBgNVHQEEVzBVgBD36H7rxqxnCUbiwGtRYQWwoS8wLTErMCkGA1UEAxMiV2Vic2l0ZXNDZXJ0aWZpY2F0ZWFwcDJkYi1kZW1vLW5ldIIQUUz5qfwBGKdMQjtiRe2mSjAJBgUrDgMCHQUAA4IBAQAWI0QR2N+Vzp9CbVzwgsyhARVyhV9Yib9sgWMwPvBgdSarhMneFGjs4DCbAf0U+SIzzZDqVSeDO4eTLvUxtupsivFsBeoTXMCeroo7tXLj9fxjv4HGo7fChHzLX3Yl6mFXFME9Pal2p1d63Rc5oTJdekcHqioaqI3NcksGVyR/XfqahY7bTr0qCfzUvFlBqyz6W2Ynz74VP9VkL5vICTWOEHzdkNR1HWoM3VF1Qh6or5a9hNKW+XcsscYfki8mUckmlLPIvFW887RJjCj+ubXiMpaal5djw/1TIzEC1afHUiY9Fm0MnQZRl6hakSDkwlYejq8UY+QNhOS09YZgN1zR"
    }

    vpn_client_protocols = ["SSTP"]
  }
}

# EOF
